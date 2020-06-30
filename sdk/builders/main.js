const { spawnSync } = require('child_process');
const fs = require('fs');
const Handlebars = require('handlebars');
const marker = '///###';

const run = (title, command, params) => {
  console.log(title);
  const cmd = spawnSync(command,params);
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
  const template = Handlebars.compile(fs.readFileSync(`./tutorials/${tutorial}.tpl`).toString());

  // TYPESCRIPT
  run('- Installing TS...','npm', ['--prefix', `./ts/${tutorial}`, 'install', `./ts/${tutorial}`]);
  run('- Building TS...','npm', ['run', 'build', '--prefix', `./ts/${tutorial}`]);
  run('- Testing TS...','node',[`ts/${tutorial}`]);
  
  console.log('- Parsing TS code...');
  const tsBlocks = collectBlocks(`./ts/${tutorial}/src/main.ts`);
  
  console.log('- Applying TS code to the template...');
  const tsResult = template(tsBlocks);

  fs.writeFileSync(`../tutorial_${tutorial}.md`, tsResult);
});
