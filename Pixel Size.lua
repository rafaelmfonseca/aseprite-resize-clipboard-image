function init(plugin)

    local function ResizeImage(data)
        -- app.alert("Pixel size: " .. data.size)
    end

    local function OpenClipboardImage()
        app.command.NewFile {
            ui = true,
            colorMode = ColorMode.RGB,
            fromClipboard = true
        }

        local sprite = app.activeSprite

        if sprite then
            app.command.ShowPixelGrid { }
            app.command.Zoom { percentage = 800, action = "in", focus = "center" }

            local dlg = Dialog { title = "Pixel Size" }
            dlg:separator { text = "Pixel properties" }
            dlg:entry { id = "size", label = "Size" }
            dlg:newrow()
            dlg:button { id = "cancel", text = "Cancel" }
            dlg:button { id = "ok", text = "OK", focus = true,
                onclick = function()
                    ResizeImage(dlg.data);
                    dlg:close();
                end
            }
            dlg:show()
        else
            app.alert("There is no valid image on clipboard.")
        end

        app.refresh()
    end

    plugin:newCommand { id = "PixelSize", title = "Pixel Size", group = "sprite_size",
        onclick = function()
            OpenClipboardImage()
        end
    }

end
