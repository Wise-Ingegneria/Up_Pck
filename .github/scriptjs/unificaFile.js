const fs = require("fs"); // per accedere al file system
const path = require("path");

/**
 * Estrae ricorsivamente tutti i file con estensione `sql` nella cartella e nei sotto-directory.
 * @param {string} folderPath - Path della cartella di input.
 * @returns {string[]} Lista di file ordinati per nome di cartella e nome di file.
 */
function extractSQLFiles(folderPath) {
  const fileList = [];

  // Funzione ricorsiva che estrae tutti i file con estensione `.sql` nella cartella e nei sottodirectory
  function extractFilesRecursively(folderPath) {
    // Leggi i contenuti della cartella
    const folderContents = fs.readdirSync(folderPath);

    folderContents.forEach((fileOrDir) => {
      // crea il path completo del file o cartella corrente
      const filePath = path.join(folderPath, fileOrDir);

      // Se il percorso è una cartella, richiama questa funzione in modo ricorsivo
      if (fs.statSync(filePath).isDirectory()) {
        extractFilesRecursively(filePath);
      } else {
        if (
          path.extname(filePath).toLowerCase() === ".sql" ||
          path.extname(filePath).toLowerCase() === ".plsql"
        ) {
          fileList.push(filePath);
        }
      }
    });
  }

  // Esegui la funzione `extractFilesRecursively` nella cartella di input `folderPath`
  extractFilesRecursively(folderPath);

  // Ordina la lista di file in modo gerarchico
  fileList.sort((fileA, fileB) => {
    const folderNameA = path.parse(path.dirname(fileA)).name;
    const folderNameB = path.parse(path.dirname(fileB)).name;

    if (folderNameA === folderNameB) {
      return path.parse(fileA).name.localeCompare(path.parse(fileB).name);
    } else {
      return folderNameA.localeCompare(folderNameB);
    }
  });

  return fileList;
}
/**
 * Aggiunge al file l'intestazione
 * @param {Buffer} file - file dove aggiungere l'intestazione
 * @param {String} heading - stringa da aggiungere
 * @returns {Buffer} - il file con l'intestazione aggiunta
 */
function addHeading(file, heading) {
  const separatore = new Array(150).join("-");
  return Buffer.concat([
    Buffer.from(
      separatore + "\n" + "-- " + heading + "\n" + separatore + "\n",
      "utf-8"
    ),
    file,
    Buffer.from("\n\n", "utf-8"),
  ]);
}

const VERSIONE_REPO_HEX = Buffer.from(
  process.env.VERSIONE || "unk",
  "utf-8"
).toString("hex");
const TAG_VERSIONE_HEX = Buffer.from("<versione>", "utf-8").toString("hex");

/**
 * Sostituisce tutti i tag `<versione>` con l'effettiva versione della release
 * @param {Buffer} contenutoFile
 * @returns {Buffer} contenuto del file con la nuova versione
 * @throws se esiste una variabile `VERSIONE ` senza releativo tag `'<versione>'`
 */
function sostituisciVersione(contenutoFile) {
  let contenutoHex = contenutoFile.toString("hex");

  contenutoHex = contenutoHex.replace(TAG_VERSIONE_HEX, VERSIONE_REPO_HEX);

  return Buffer.from(contenutoHex, "hex");
}

/**
 * Unisce una lista di file in un unico file ordinato e lo salva su disco.
 * @param {string[]} fileList - Elenco dei path dei file da unire.
 * @param {string} outputPath - Path del file di output.
 */
function mergeFiles(fileList, outputPath) {
  // lettura dei contenuti dei file nell'array
  const fileContents = fileList.map((filePath) =>
    addHeading(
      sostituisciVersione(fs.readFileSync(filePath)),
      path.dirname(filePath) + "/" + path.basename(filePath)
    )
  );

  // unione dei contenuti in un unico buffer
  const mergedContents = Buffer.concat(fileContents);

  // scrittura del contenuto nel file di output
  fs.writeFileSync(outputPath, mergedContents);

  console.info(`I file sono stati uniti con successo in ${outputPath}`);
}

try {
  mergeFiles(extractSQLFiles("."), "unificato.plsql");
  process.exit(0);
} catch (error) {
  console.error(error);
  process.exit(1);
}
