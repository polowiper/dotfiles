const fs = require('fs');
const crypto = require('crypto');

const license = {
    header: { version: 1 },
    payload: {
        name: 'auth',
        email: 'admin@hex-rays.com',
        licenses: [
            {
                description: 'license',
                edition_id: 'ida-pro',
                id: '14-0000-FFFF-88',
                license_type: 'named',
                product: 'IDA',
                seats: 1,
                start_date: '2024-08-10 00:00:00',
                end_date: '2033-12-31 23:59:59',
                issued_on: '2025-07-20 00:00:00',
                owner: 'auth',
                product_id: 'IDAPRO',
                product_version: '9.2',
                add_ons: [],
                features: [],
            }
        ],
    },
};

function addons(license) {
    var addons = [ //update as needed
        'LUMINA', 'TEAMS',
        'HEXX86', 'HEXX64', 'HEXARM', 'HEXARM64',
        'HEXMIPS', 'HEXMIPS64', 'HEXPPC', 'HEXPPC64',
        'HEXRV', 'HEXRV64', 'HEXARC', 'HEXARC64'
    ];

    addons.forEach((addon, i) => {
        license.payload.licenses[0].add_ons.push({
        id: `48-1337-B00B-${String(i + 1).padStart(2, '0')}`,
        code: addon,
        owner: license.payload.licenses[0].id,
        start_date: '2025-07-20 00:00:00',
        end_date: '2033-12-31 23:59:59',
        });
    });
}
addons(license);

// --- Helper funcs ---
//recursive sorting into json string
function sort(obj) {
    if (Array.isArray(obj)) {
        return '[' + obj.map(sort).join(',') + ']';
    } else if (obj && typeof obj === 'object' && obj !== null) {
        var keys = Object.keys(obj).sort();
        return '{' + keys.map(k => '"' + k + '":' + sort(obj[k])).join(',') + '}';
    } else {
        return JSON.stringify(obj);
    }
}

const cModulus = Buffer.from("edfd42cbf978546e8911225884436c57140525650bcf6ebfe80edbc5fb1de68f4c66c29cb22eb668788afcb0abbb718044584b810f8970cddf227385f75d5dddd91d4f18937a08aa83b28c49d12dc92e7505bb38809e91bd0fbd2f2e6ab1d2e33c0c55d5bddd478ee8bf845fcef3c82b9d2929ecb71f4d1b3db96e3a8e7aaf93", "hex");
const privateKey = Buffer.from("77c86abbb7f3bb134436797b68ff47beb1a5457816608dbfb72641814dd464dd640d711d5732d3017a1c4e63d835822f00a4eab619a2c4791cf33f9f57f9c2ae4d9eed9981e79ac9b8f8a411f68f25b9f0c05d04d11e22a3a0d8d4672b56a61f1532282ff4e4e74759e832b70e98b9d102d07e9fb9ba8d15810b144970029874", "hex");

function encrypt(message) {
    let modulusBuf = 0n;
    for (let i = cModulus.length - 1; i >= 0; i--)
        modulusBuf = (modulusBuf << 8n) + BigInt(cModulus[i]);
    
    let keyBuf = 0n;
    for (let i = privateKey.length - 1; i >= 0; i--)
        keyBuf = (keyBuf << 8n) + BigInt(privateKey[i]);
    
    var reversed = Buffer.from(message).reverse();
    
    let msgBuf = 0n;
    for (let i = reversed.length - 1; i >= 0; i--)
        msgBuf = (msgBuf << 8n) + BigInt(reversed[i]);

    let base = msgBuf % modulusBuf, exponent = keyBuf, modulus = modulusBuf, encryptedBigInt = 1n;
    while (exponent > 0n) {
        if (exponent % 2n === 1n) 
            encryptedBigInt = (encryptedBigInt * base) % modulus;
        exponent >>= 1n; base = (base * base) % modulus;
    }

    var bytes = [];
    for (let buffer = encryptedBigInt; buffer > 0n; buffer >>= 8n) bytes.push(Number(buffer & 0xFFn));
    return Buffer.from(bytes);
}

function patch(filePath, search, replace) {
    try {
        const buf = fs.readFileSync(filePath);
        const idx = buf.indexOf(search);
        if (idx !== -1) {
            buf.set(replace, idx);
            fs.writeFileSync(filePath, buf);
            console.log(`Patched ${filePath}`);
            return;
        }
        else {
            console.error(`Pattern not found in ${filePath}`);
            return;
        }
    } catch (err) {
        console.error(`Error reading or writing file: ${filePath}`);
        console.error('Elevated permissions given?')
        return;
    }
}

function sign(payload) {
  var data = { payload };
  var dataStr = sort(data);

  var buffer = Buffer.alloc(128, 0);
  buffer.fill(0x42, 0, 33); // first 33 bytes filled with 0x42

  var hash = crypto.createHash('sha256').update(dataStr).digest();
  hash.copy(buffer, 33); // copy hash after first 33 bytes

  var encrypted = encrypt(buffer);
  return encrypted.toString('hex').toUpperCase();
}
license.signature = sign(license.payload);

// --- Write License to file ---
fs.writeFileSync('idapro.hexlic', sort(license));
console.log('License written to idapro.hexlic');

// --- Patcher ---
const search = Buffer.from('EDFD425CF978', 'hex');
const replace = Buffer.from('EDFD42CBF978', 'hex');

["ida.dll", "ida32.dll", "libida.so", "libida32.so", "libida.dylib", "libida32.dylib"].forEach(file => {
  if (fs.existsSync(file)) {
    console.log(`Patching ${file}...`);
    patch(file, search, replace);
  }
});