
import * as Fs from "fs";
import * as Path from "path";

const certification = JSON.parse(Fs.readFileSync(Path.join(process.cwd(), "keys", "api-project-211707321887-firebase-adminsdk-lzsd4-5c55881ac5.json")).toString());

const databaseUrl = 'https://api-project-211707321887.firebaseio.com';

export { certification, databaseUrl }
