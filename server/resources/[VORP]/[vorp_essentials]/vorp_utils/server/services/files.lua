FilesAPI = {}

-- GetCurrentResourceName()
function FilesAPI:Open(resourcename, filepath)
    if IsEmpty(resourcename) or IsEmpty(filepath) then
        print("You must have a resource name and filepath defined!")
        return {}
    end
    
    
    local FileClass = {}
    FileClass.ResourceName = resourcename
    FileClass.FilePath = filepath

    function FileClass:Read(mode)
        local filedata = LoadResourceFile(self.ResourceName, self.FilePath)

        if CheckMode(mode) then
            filedata = json.decode(filedata)
        end

        return filedata
    end

    function FileClass:Save(content, mode, dataLenght)
        if CheckMode(mode) then
            content = json.encode(content)
        end

        SaveResourceFile(self.ResourceName, self.FilePath, content,dataLenght)
    end

    function FileClass:Update(content, mode, dataLenght)
        local filedata =  LoadResourceFile(self.ResourceName, self.FilePath)

        if CheckMode(mode) then
            local table = json.decode(filedata)
            table[#table+1] = content
            filedata = json.encode(table)
        else
            filedata = filedata .. content
        end

        SaveResourceFile(self.ResourceName, self.FilePath, filedata,dataLenght )
    end

    return FileClass
end

-- Lazy functions, not as optimized
function FilesAPI:Load(resourcename, filepath, mode)
    local file = FilesAPI:Open(resourcename, filepath)
    return file:Read(mode)
end

function FilesAPI:Save(resourcename, filepath, content, mode)
    local file = FilesAPI:Open(resourcename, filepath)
    file:Save(content, mode)
end

function FilesAPI:Update(resourcename, filepath, content, mode)
    local file = FilesAPI:Open(resourcename, filepath)
    file:Update(content, mode)
end
