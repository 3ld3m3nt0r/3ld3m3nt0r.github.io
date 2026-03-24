---
title: "Nodejs"
description: "Apuntes de node js"
tags: []
categories: []
home_image: banner
banner:
  path: https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Node.js_logo.svg/1280px-Node.js_logo.svg.png
  alt: "nodejs"
---

```js
import fs from "node:fs/promises"
import path from "node:path"
import pc from "picocolors"

console.log(
  pc.green(`How are ${pc.italic(`you`)} doing?`)
)

const folder = process.argv[2] ?? '.'

async function ls(folder) {
    let files
    try {
        files = await fs.readdir(folder)
    } catch {
        console.error(`No se pudo leer el directorio ${folder}`)
        process.exit(1)
    }

    const filePromises = files.map(async file => {
        const filePath = path.join(folder, file)
        let stats
        try {
            stats = await fs.stat(filePath)
        } catch {
            console.error(`No se pudo leer el archivo ${filePath}`)
            process.exit(1)
        }

        const isDirectory = stats.isDirectory()
        const fileType = isDirectory ? 'd' : 'f'
        const fileSize = stats.size
        const fileModified = stats.mtime.toLocaleString()
        return `${fileType} ${file.padEnd(20)} ${fileSize.toString().padEnd(10)} ${fileModified}`

    })
    console.log(Object.entries(filePromises))
    
    const filesInfo = await Promise.all(filePromises)
    filesInfo.forEach(fileinfo => console.log(fileinfo))
}

ls(folder)
```