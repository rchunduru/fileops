
fs = require 'fs'
path = require 'path'
exec = require('child_process').exec
log = console.log

class fileops
    createFile: (filename, callback) ->
        try
            dir = path.dirname filename
            unless path.existsSync dir
                log 'no path exists'
                exec "mkdir -p #{dir}", (error, stdout, stderr) =>
                    unless error
                        log 'created path'
                        exec "touch #{filename}"
            else
                log 'path exists'
                exec "touch #{filename}", (error, stdout, stderr) =>
                    callback(error) if error
                    callback(true)
        catch err
            log  "Unable to create file #{filename}"
            callback (err)

    removeFile: (filename, callback) ->
        fs.unlink filename, (error)->
            callback(error)

    removeFileSync: (filename) ->
        res = fs.unlinkSync filename
        return res

    updateFile: (filename, content) ->
        fs.writeFileSync filename, content

    fileExists: (filename, callback) ->
        #Note: fs.existsSync did not work.
        if path.existsSync filename
            log 'file exists'
            callback({result:true})
        else
            log 'File does not exist'
            error = new Error "File does not exist"
            callback(error)

    fileExistsSync: (filename) ->
        if path.existsSync filename
            return true
        else
            return new Error "File does not exist"

    readFile: (filename, callback) ->
        @fileExists filename, (result) ->
            if result instanceof Error
                callback(result)
            else
                log 'reading the file'
                buf = fs.readFileSync filename
                callback(buf)

    readFileSync: (filename) ->
        if path.existsSync filename
            content = fs.readFileSync filename, 'utf8'
            console.log 'content is ' + content
            return content
        else
            return new Error "file #{filename} does not exist"

    readdirSync: (dirname) ->
        if path.existsSync dirname
            content = fs.readdirSync dirname
            return content
        else
            return new Error "Directory #{dirname} does not exist"

       
module.exports = new fileops
