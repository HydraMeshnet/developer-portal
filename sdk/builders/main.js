const { spawnSync } = require('child_process');
const fs = require('fs');
const Handlebars = require('handlebars');
const marker = '///###';

const run = (dir, title, command, params) => {
  console.log(title);
  const cmd = spawnSync(command,params, {cwd: dir});
  if(cmd.error) {
    console.log(`ERROR: ${cmd.error}`);
    process.exit(1);
  }

  if(cmd.stderr && cmd.stderr.toString()) {
    console.log(`ERROR: ${cmd.stderr}`);
    process.exit(1);
  }
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
  'dac_contract',
];

tutorials.forEach(tutorial => {
  console.log(`### ${tutorial} ###`);
  let template = Handlebars.compile(fs.readFileSync(`./templates/${tutorial}.tpl`).toString());

  // TYPESCRIPT
  /*run(`./ts/${tutorial}`, '- Installing TS...','npm', ['install']);
  run(`./ts/${tutorial}`, '- Building TS...','npm', ['run', 'build']);
  run(`./ts/${tutorial}`, '- Testing TS...','node',['.']);*/

  // FLUTTER
  //run(`./flutter/${tutorial}`, '- Installing Flutter...','flutter',['pub','get']);
  //run(`./flutter/${tutorial}`, '- Testing Flutter...','flutter',['test']);
  
  console.log('- Parsing TS code...');
  const tsBlocks = collectBlocks(`./ts/${tutorial}/src/main.ts`);

  console.log('- Parsing Flutter code...')
  const flutterBlocks = collectBlocks(`./flutter/${tutorial}/lib/main.dart`);

  const blocks = {
    ...tsBlocks,
    ...flutterBlocks,
  };
  
  console.log('- Applying code to the template...');
  const result = template(blocks);

  fs.writeFileSync(`../tutorial_${tutorial}.md`, result);
});
