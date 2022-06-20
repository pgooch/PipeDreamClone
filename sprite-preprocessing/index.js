var Jimp = require('jimp');
var fs = require('fs');

const SOURCE_DIR = "./exported/";
const TILE_SIZE = 29; // I'm only using this to com pile the bulk tile sprite sheet

// Smarter sorting from SO: https://stackoverflow.com/questions/2802341/javascript-natural-sort-of-alphanumerical-strings
var collator = new Intl.Collator(undefined, {numeric: true, sensitivity: 'base'});



// Before we can generate we need to prep; the size of the final sheet, the locations/data for
// creation, and the options we need to run on the tiles during generation.
let tileGenerationData = []
let totalNumberOfTiles = 0;
const tileDirs = fs.readdirSync(SOURCE_DIR).sort(collator.compare);
for (const tileDir of tileDirs){
    if( tileDir.substr(0,1) != "."){
        const graphicFiles = fs.readdirSync(SOURCE_DIR+tileDir).filter(n => n.substr(0,1)!=".").sort(collator.compare);
        const newTileData = {
            automaticReverse: tileDir.indexOf("-noreverse") < 0,
            directoryName: tileDir+"/",
            tileName: tileDir.split(' ')[1],
            baseFile: graphicFiles.filter(n => n.match(/base\./)),
            fillFiles: graphicFiles.filter(n => !n.match(/base\./)).sort(collator.compare),
        };
        totalNumberOfTiles += newTileData.fillFiles.length * ( newTileData.automaticReverse ? 2 : 1);
        tileGenerationData.push(newTileData)
    }
}
const sheetCols = Math.ceil(Math.sqrt(totalNumberOfTiles));
const sheetRows = Math.round(Math.sqrt(totalNumberOfTiles));
console.log("Looking to build a",sheetCols,"by",sheetRows,"sprite sheet to contain",totalNumberOfTiles,"sprites.")



// Generate a new sheet and move the base + fill amount over.
const generateFinalSpriteSheet = async () => {
    let workingX = 0;
    let workingY = 0;
    const finalSheet = await new Jimp(sheetCols*TILE_SIZE, sheetRows*TILE_SIZE, 'orange');
    for (tile of tileGenerationData){
        const tileBase = await Jimp.read(SOURCE_DIR+tile.directoryName+tile.baseFile);
        for (fill of tile.fillFiles){
            const fillOverlay = await Jimp.read(SOURCE_DIR+tile.directoryName+fill);

            await finalSheet.blit(tileBase, workingX*TILE_SIZE, workingY*TILE_SIZE);
            await finalSheet.blit(fillOverlay, workingX*TILE_SIZE, workingY*TILE_SIZE);
            workingX++;
            if (workingX >= sheetCols) {
                workingX = 0;
                workingY++;
            }
        }
        if(tile.automaticReverse){
            for (fill of tile.fillFiles.reverse()){
                const fillOverlay = await Jimp.read(SOURCE_DIR+tile.directoryName+fill);
                fillOverlay.invert();

                await finalSheet.blit(tileBase, workingX*TILE_SIZE, workingY*TILE_SIZE);
                await finalSheet.blit(fillOverlay, workingX*TILE_SIZE, workingY*TILE_SIZE);
                workingX++;
                if (workingX >= sheetCols) {
                    workingX = 0;
                    workingY++;
                }
            }
        }
    }

    await finalSheet.write("./test.png");
    console.log('Saved.')

}
generateFinalSpriteSheet();
