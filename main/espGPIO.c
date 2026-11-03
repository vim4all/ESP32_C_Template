#include "espGPIO.h"
#include "esp_log.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

static const char *TAG = "espGPIO";

void my_led_initialize(void)
{
    gpio_config_t cfg = {
        .mode         = GPIO_MODE_OUTPUT,
        .pin_bit_mask = (1ULL << BLINK_GPIO_1) | (1ULL << BLINK_GPIO_2),
    };
    ESP_ERROR_CHECK(gpio_config(&cfg));
    gpio_set_level(BLINK_GPIO_1, 0);
    gpio_set_level(BLINK_GPIO_2, 0);
    ESP_LOGI(TAG, "LEDs initialised on GPIO %d and %d", BLINK_GPIO_1, BLINK_GPIO_2);
}

void my_led_blink(uint16_t led_num, uint16_t amount, uint16_t delay_ms)
{
    if (led_num != 1 && led_num != 2) return;
    gpio_num_t pin = (led_num == 1) ? BLINK_GPIO_1 : BLINK_GPIO_2;
    for (uint16_t i = 0; i < amount; i++) {
        gpio_set_level(pin, 1);
        vTaskDelay(pdMS_TO_TICKS(delay_ms));
        gpio_set_level(pin, 0);
        vTaskDelay(pdMS_TO_TICKS(delay_ms));
    }
}

void my_led_set(uint16_t led_num, int level)
{
    if (led_num == 1)      gpio_set_level(BLINK_GPIO_1, level);
    else if (led_num == 2) gpio_set_level(BLINK_GPIO_2, level);
}
