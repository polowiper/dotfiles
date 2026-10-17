// Made specifically for IDA 9.4 beta1
// May not work for other versions of this software including future ones

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
                product_version: '9.4',
                add_ons: [],
                features: [],
            }
        ],
    },
};

function addons(license) {
    var addons = [ //update as needed, doesnt include cloud addons
        'LUMINA', 'TEAMS',
        'HEXX86', 'HEXX64', 'HEXARM', 'HEXARM64',
        'HEXMIPS', 'HEXMIPS64', 'HEXPPC', 'HEXPPC64',
        'HEXRV', 'HEXRV64', 'HEXARC', 'HEXARC64',
        'HEXV850', 'HEXDALVIK'
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

const cModulus   = Buffer.from("3f0307607fed562fd5a163adc40fcc603373caa28414e64cdc4552a555b13ad4b3ad0a812800a03195300fd71634b90edb0d69ea710efebb2b0b9e72da2effb149de70bcbfa94b86af01ce455dbbd5fa987207651c7b60c2e4cafd0654188d98c30f64dc084d8547f0ac32db91124af82b3b15bf922a31f1d5e332f27615cea7", "hex");
const privateKey = Buffer.from("8b3f5fdfad7f87239734c530e2ecebeb4fa48d79518756c15fd54636801cf7ea6367100566bf8b52b16bec05258d8426ea94c15841ab2d37802c07349df4c208584e86d25a6bfb82966cb2ddcd3d654e9994e814ca470577362a937cc984e404a0b68d173aab3180130118e1b03ed209a9d8757560a85a3c9b0d3380e7907c4f", "hex");

const V54 = 127;
const V56 = 95;
const PADKEY = Buffer.from("e2a7c300dfcc777f89b57500d8151c7fb1d97b3f9f170393311234ceeb9e377ae2a7c300dfcc777f89b57500d8151c7fb1d97b3f9f170393311234ceeb9e377ae2a7c300dfcc777f89b57500d8151c7fb1d97b3f9f170393311234ceeb9e377ae2a7c300dfcc777f89b57500d8151c7fb1d97b3f9f170393311234ceeb9e37", "hex");

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
        let count = 0, idx = buf.indexOf(search);
        while (idx !== -1) {
            buf.set(replace, idx);
            count++;
            idx = buf.indexOf(search, idx + search.length);
        }
        if (count > 0) {
            fs.writeFileSync(filePath, buf);
            console.log(`Patched ${filePath} (${count} occurrence${count === 1 ? '' : 's'})`);
        } else {
            console.error(`Pattern not found in ${filePath}`);
        }
    } catch (err) {
        console.error(`Error reading or writing file: ${filePath}`);
        console.error('Elevated permissions given?')
        return;
    }
}

function sign(payload) {
  var dataStr = sort({ payload });
  var hash = crypto.createHash('sha256').update(dataStr).digest(); // 32 bytes

  var U = Buffer.alloc(V54, 0);
  hash.copy(U, V56);
  var block = Buffer.alloc(V54);
  for (var i = 0; i < V54; i++) block[i] = U[i] ^ PADKEY[i];
  if (block[0] === 0) block[0] ^= 1;

  var sig = encrypt(block);
  var out = Buffer.alloc(128, 0);
  sig.copy(out, 0);
  return out.toString('hex').toUpperCase();
}
license.signature = sign(license.payload);

// --- Write License to file ---
fs.writeFileSync('idapro.hexlic', sort(license));
console.log('License written to idapro.hexlic');

// --- Patcher ---
const search  = Buffer.from("29f4481f796f9f66f2ff13cc4ab5b54f60845db603ba2c0bac8a9bc4b6cbdefc5c62bfc2f5ee850ac45ea97ad347e8b56dba5085af8c8aad9cc2ec626ca78a068006d658f68651da31a0a77c65a70ed73a40d53b08edd403c095aa0bcffa52f313ebcacaaa2ce5024a4e2b9aa70fc6092f38ae094d71e43f7690b5ddd3e9e4f7", "hex");
const replace = Buffer.from("a107b71c8a08ba5350934f7cf6e81be3a24dc2e35f7200d80cbd70b37ed6811dd2146d3cb7e20ad19b2544c0ef14c5c66ffbbdf226ec3f3d544c04385303ca4a7179299340022f5d50948bcf8a60307e2c196329e51a5296dc419e40fef3ef7c6f015a09ebd979e79615338985643e666c14897f9f597e11f44341f496d56861", "hex");

["ida.dll", "ida32.dll", "libida.so", "libida32.so", "libida.dylib", "libida32.dylib"].forEach(file => {
  if (fs.existsSync(file)) {
    console.log(`Patching ${file}...`);
    patch(file, search, replace);
  }
});

const os = require('os');
if (os.platform() === 'darwin') {
  console.log('I noticed you\'re currently running MacOS, you will have to resign both \"libida32.dylib\" and \"libida.dylib\" or else IDA will not start up.')
  console.log('You can do so by running the following commands:')
  console.log(' # codesign --verbose --force --deep --sign - ./libida.dylib')
  console.log(' # codesign --verbose --force --deep --sign - ./libida32.dylib\n')
  console.log('Alternatively you can disable Security Features like Gatekeeper to avoid this restriction, however I do not recommend doing this.')
}
