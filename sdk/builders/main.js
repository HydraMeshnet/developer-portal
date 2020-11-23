const { spawnSync } = require('child_process');
const fs = require('fs');
const Handlebars = require('handlebars');
const marker = '///###';

const run = (dir, title, command, params) => {
  console.log(title);
  const cmd = spawnSync(command,params, {cwd: dir});
  if(cmd.error && !cmd.error.toString().includes('secp256k1')) {
    console.log(`ERROR: ${cmd.error}`);
    process.exit(1);
  }

  if(cmd.stderr && cmd.stderr.toString() && !cmd.stderr.includes('secp256k1')) {
    console.log(`ERROR: ${cmd.stderr}`);
    process.exit(1);
  }

  return cmd.stdout.toString();
};

const collectBlocks = (path) => {
  let inBlock = false;
  let inBlockName;
  const blocks = {};
  const code = fs.readFileSync(path).toString();
  for(const line of code.split('\n')) {
    if(line.trim().startsWith(marker)) {
      if(inBlock) {
        inBlock = false;
        inBlockName = undefined;
      }
      else {
        inBlock = true;
        inBlockName = line.trim().replace(marker,'');
      }
      continue;
    }

    if(!inBlock) {
      continue;
    }

    if(!blocks[inBlockName]) {
      blocks[inBlockName] = [];
    }

    blocks[inBlockName].push(line);
  }

  Object.keys(blocks).forEach(key => {
    blocks[key] = blocks[key].join('\n');
  });

  return blocks;
};

const tutorials = [
  'send_hyd',
  'create_vault',
  'send_hyd_vault',
  'ssi_contract',
];

tutorials.forEach(tutorial => {
  console.log(`### ${tutorial} ###`);
  let template = Handlebars.compile(fs.readFileSync(`./templates/${tutorial}.tpl`).toString());

  // TYPESCRIPT
  run(`./ts/${tutorial}`, '- Installing TS...','npm', ['install']);
  run(`./ts/${tutorial}`, '- Building TS...','npm', ['run', 'build']);
  run(`./ts/${tutorial}`, '- Testing TS...','node',['.']);

  // FLUTTER
  const flutterSoZip = './test/Linux-x86.zip';
  run(`./flutter/${tutorial}`, '- Installing Flutter Native Lib...','curl',['-sS','--proto','=https','--tlsv1.2','-#L','-o',flutterSoZip,'https://github.com/Internet-of-People/iop-rs/releases/latest/download/Linux-x86.zip']);
  run(`./flutter/${tutorial}`,' - Unzipping...', 'unzip',['-o',flutterSoZip, '-d','./test']);
  run(`./flutter/${tutorial}`,' - Cleanup...', 'rm',[flutterSoZip]);
  run(`./flutter/${tutorial}`, '- Installing Flutter...','flutter',['pub','get']);
  const flutterOut = run(`./flutter/${tutorial}`, '- Testing Flutter...','flutter',['test']);
  if(flutterOut.indexOf('Test failed') > -1 || flutterOut.indexOf('Some tests failed') > -1) {
    console.log(flutterOut);
    process.exit(1);
  }

  console.log('- Parsing TS code...');
  const tsBlocks = collectBlocks(`./ts/${tutorial}/src/main.ts`);

  console.log('- Parsing Flutter code...')
  const flutterBlocks = collectBlocks(`./flutter/${tutorial}/test/main_test.dart`);

  const blocks = {
    ...tsBlocks,
    ...flutterBlocks,
  };
  
  console.log('- Applying code to the template...');
  const result = template(blocks);

  fs.writeFileSync(`../tutorial_${tutorial}.md`, result);
});
