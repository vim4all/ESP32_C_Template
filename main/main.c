#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"

#include "espGPIO.h"

static const char *TAG = "main";

static void task_blink(void *arg)
{
    while (1) {
        my_led_blink(1, 1, 500);
        my_led_blink(2, 1, 500);
    }
}

void app_main(void)
{
    ESP_LOGI(TAG, "ESP32 C template — LED blink");

    my_led_initialize();

    xTaskCreate(task_blink, "blink", 2048, NULL, 5, NULL);
}
