
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
            callback(true)

    readFile: (filename, callback) ->
        @fileExists filename, (result) ->
            if result instanceof Error
                callback(result)
            else
                log 'reading the file'
                buf = fs.readFileSync filename
                callback(buf)

       
module.exports = new fileops
