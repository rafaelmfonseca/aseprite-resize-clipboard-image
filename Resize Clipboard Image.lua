function init(plugin)

    local function ResizeClipboardImage(dlg)
        local sprite = app.activeSprite
        local pixelSize = tonumber(dlg.data.size)

        local originalImage = sprite.layers[1]:cel(1).image
        
        local resizedLayer = sprite:newLayer()
        resizedLayer.name = "Layer Resized"
        sprite:newCel(resizedLayer, 1)

        local resizedImage = resizedLayer:cel(1).image

        for x = 0, originalImage.width - 1, 1
        do
            for y = 0, originalImage.height - 1, 1
            do
                if (x % pixelSize == 0) and (y % pixelSize == 0) then
                    local newX = x / pixelSize
                    local newY = y / pixelSize

                    resizedImage:drawPixel(newX, newY, originalImage:getPixel(x, y))
                end
            end
        end

        sprite:deleteLayer("Layer 1")

        app.command.AutocropSprite { }
        app.command.ShowPixelGrid { }
        app.command.FitScreen { }
        app.useTool { tool = "rectangular_marquee", selection = SelectionMode.REPLACE }

        app.refresh()
    end

    local function OpenClipboardImage()
        app.command.NewFile {
            ui = true,
            colorMode = ColorMode.RGB,
            fromClipboard = true
        }

        local sprite = app.activeSprite

        local dlg = Dialog { title = "Pixel Size" }
        dlg:separator { text = "Pixel properties" }
        dlg:entry { id = "size", label = "Size", text = "4" }
        dlg:newrow()
        dlg:button { id = "cancel", text = "Cancel" }
        dlg:button { id = "ok", text = "OK", focus = true,
            onclick = function()
                ResizeClipboardImage(dlg)
                dlg:close()
            end
        }

        if sprite then
            app.command.ShowPixelGrid { }
            app.command.Zoom { percentage = 800, action = "in", focus = "center" }
            dlg:show()
        else
            app.alert("There is no valid image on clipboard.")
            dlg:close()
        end

        app.refresh()
    end

    plugin:newCommand { id = "ResizeClipboardImage", title = "Resize Clipboard Image", group = "sprite_size",
        onclick = function()
            OpenClipboardImage()
        end
    }

end
