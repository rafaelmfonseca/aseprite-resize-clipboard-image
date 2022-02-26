function init(plugin)

    function ResizePixel()
        local dlg = Dialog {
            title = "Pixel Size"
        }
        
        dlg:button {
            id = "cancel",
            text = "Cancel"
        }
        dlg:button {
            id = "ok",
            text = "OK",
            focus = true,
            onclick = function()
                local args = dlg.data

                if args.ok then
                    app.command.NewFile {
                        ui = true,
                        colorMode = ColorMode.RGB,
                        fromClipboard = true
                    }

                    local sprite = app.activeSprite

                    if sprite then
                        -- sprite.layers[1]:cel(1).image:drawPixel(0, 0, Color(199,90,104));
                        -- local sprite = Sprite(10, 10)

                        app.command.GridSettings {
                            ui = true,
                            width = 1,
                            height = 1,
                            gridBounds = Rectangle(0, 0, 1, 1)
                        }
                    else
                        app.alert("There is no valid image on clipboard.")
                    end

                    app.refresh()
                    dlg:close()
                end
            end
        }
        dlg:show()
    end

    plugin:newCommand {
        id = "PixelSize",
        title = "Pixel Size",
        group = "sprite_size",
        onclick = function()
            ResizePixel()
        end
    }

end
