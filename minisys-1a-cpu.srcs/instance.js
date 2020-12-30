// 快速例化 by z0gSh1u @ 2020-12
// node instance.js <path_to_.v_file>
const fs = require('fs')
const path = require('path')
const vPath = process.argv.slice(2)[0]
const vModule = path.basename(vPath, '.v')
const vContent = String(fs.readFileSync(vPath))
const vLines = vContent.replace(/\r\n/g, '\n').split('\n')
const ios = []
vLines.forEach((line) => {
  line = line.trim()
  const isInput = line.startsWith('input')
  const isOutput = line.startsWith('output')
  if (isInput || isOutput) {
    const type = ['input', 'output'][+isOutput]
    ios.push({
      type,
      follow: line
        .replace(new RegExp(`${type}\\s+(reg|wire)?`), '')
        .replace(type, '')
        .replace(',', '')
        .trim(),
    })
  }
})
let output = '// 被测信号\n'
ios.forEach((v) => {
  let commentIndex = v.follow.indexOf('//')
  if (commentIndex == -1) commentIndex = v.follow.length
  const comment = v.follow.substring(commentIndex)
  output +=
    ['reg ', 'wire '][+(v.type == 'output')] +
    v.follow.substring(0, commentIndex).trim() +
    `; ${comment}\n`
})
output += '\n// 例化被测模块\n'
output += `${vModule} u_${vModule}(\n`
ios.forEach((v, i) => {
  const port = v.follow
    .replace(/\/\/.*/, '')
    .trim()
    .split(/\s+/)
    .slice(-1)[0]
  output += `  .${port}(${port})${i == ios.length - 1 ? '' : ','}\n`
})
output += ');'
process.stdout.write(output)
