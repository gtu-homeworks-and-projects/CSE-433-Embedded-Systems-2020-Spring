#include <IR_Remote.h>

void DWT_Init()
{
	CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
	DWT->CYCCNT = 0;
	DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
}
/////////////////////////////////////////////////////////////////////////////////


void sendRaw(uint16_t buf[], unsigned int len, uint8_t hz)
{
	enableIROut(hz);
	int skipFirst = 0;
	if (buf[0] > 10000) {
		skipFirst = 1;
	}

	for(uint16_t i = skipFirst; i < len; i++)
	{
		if(i % 2 != skipFirst) space(buf[i]*USECPERTICK);
		else mark(buf[i]*USECPERTICK);
	}

	space(0);
}

void mark(unsigned int time)
{
	HAL_TIM_PWM_Start(&htim4, TIM_CHANNEL_1);
	if (time > 0) custom_delay_usec(time);
}

void space(unsigned int time)
{
	HAL_TIM_PWM_Stop(&htim4, TIM_CHANNEL_1);
	if(time > 0) custom_delay_usec(time);
}

void enableIROut(uint8_t khz)
{
	uint16_t pwm_freq = 0;
	uint16_t pwm_pulse = 0;
	pwm_freq = MYSYSCLOCK / (khz * 1000) - 1;
	pwm_pulse = pwm_freq / 3;

	HAL_TIM_Base_DeInit(&htim4);

	TIM_ClockConfigTypeDef sClockSourceConfig = {0};
	TIM_MasterConfigTypeDef sMasterConfig = {0};
	TIM_OC_InitTypeDef sConfigOC = {0};

	htim4.Instance = TIM4;
	htim4.Init.Prescaler = 0;
	htim4.Init.CounterMode = TIM_COUNTERMODE_UP;
	htim4.Init.Period = pwm_freq;
	htim4.Init.ClockDivision = TIM_CLOCKDIVISION_DIV1;
	htim4.Init.AutoReloadPreload = TIM_AUTORELOAD_PRELOAD_DISABLE;
	HAL_TIM_Base_Init(&htim4);

	sClockSourceConfig.ClockSource = TIM_CLOCKSOURCE_INTERNAL;
	HAL_TIM_ConfigClockSource(&htim4, &sClockSourceConfig);
	HAL_TIM_PWM_Init(&htim4);

	sMasterConfig.MasterOutputTrigger = TIM_TRGO_RESET;
	sMasterConfig.MasterSlaveMode = TIM_MASTERSLAVEMODE_DISABLE;
	HAL_TIMEx_MasterConfigSynchronization(&htim4, &sMasterConfig);

	sConfigOC.OCMode = TIM_OCMODE_PWM1;
	sConfigOC.Pulse = pwm_pulse;
	sConfigOC.OCPolarity = TIM_OCPOLARITY_HIGH;
	sConfigOC.OCFastMode = TIM_OCFAST_DISABLE;
	HAL_TIM_PWM_ConfigChannel(&htim4, &sConfigOC, TIM_CHANNEL_1);
	HAL_TIM_MspPostInit(&htim4);
}

void custom_delay_usec(unsigned long us)
{
	uint32_t us_count_tic =  us * (HAL_RCC_GetSysClockFreq() / 1000000);
	DWT->CYCCNT = 0U;
	while(DWT->CYCCNT < us_count_tic);
}
