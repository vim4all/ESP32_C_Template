#ifndef ESPGPIO_H
#define ESPGPIO_H

#include <stdint.h>
#include "driver/gpio.h"

#define BLINK_GPIO_1 4
#define BLINK_GPIO_2 5

void my_led_initialize(void);
void my_led_blink(uint16_t led_num, uint16_t amount, uint16_t delay_ms);
void my_led_set(uint16_t led_num, int level);

#endif // ESPGPIO_H
