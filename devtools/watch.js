const fs = require('fs');
const path = require('path');

const pathInput = path.resolve('../');
const pathOutput = path.resolve(process.env.APPDATA, 'Aseprite', 'extensions', 'aseprite-resize-clipboard-image');

const filesToCopy = [
    'package.json',
    'Resize Clipboard Image.lua',
];

fs.watch(pathInput, (eventType, filename) => {
    if (eventType === 'change' && filesToCopy.indexOf(filename) != -1) {
        const inputFile = path.resolve(pathInput, filename);
        const outputFile = path.resolve(pathOutput, filename);

        fs.copyFileSync(inputFile, outputFile);

        console.log(`File ${filename} moved!`);
    }
});
