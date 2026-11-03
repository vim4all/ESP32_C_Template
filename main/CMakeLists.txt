idf_component_register(SRCS "main.c"
                            "espGPIO.c"
                    INCLUDE_DIRS "."
                    REQUIRES
                        esp_driver_gpio
                        freertos
                        log)
