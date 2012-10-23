fileops = require '../lib/fileops'

content = fileops.readFileSync "/sys/class/net/lo/operstate"
console.log content
content = fileops.readdirSync "/sys/class/net/lo"
console.log content
