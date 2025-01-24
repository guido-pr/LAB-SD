byte HOR[8] = {0x09,0x01,0x03,0x02,0x06,0x04,0x0c,0x08};    // Matriz dos bytes das Fases do Motor - sentido Horário 
byte AHO[8] = {0x08,0x0c,0x04,0x06,0x02,0x03,0x01,0x09};    // Matriz dos bytes das Fases do Motor - sentido Anti-Horário 
int atraso_fase = 1 ;                                       // Intervalo de tempo entre as fases em milisegundos
int intervalo = 1000 ;                                      // Intervalo de tempo entre os movimentos do motor em ms
void Motor_AHO()                    // Movimento no sentido anti-horário 
{
  for(int i = 0; i < 512; i++)      // incrementa o contador i de 0 a 511 - uma volta
  
    for(int j = 0; j < 8; j++)      // incrementa o contador j de 0 a 7 
    {
      PORTB = AHO[j];               // Carrega bytes da Matriz AHO na Porta B 
      delay (atraso_fase);          // Atraso de tempo entre as fases em milisegundos
    }    
}
void Motor_HOR()                    // Movimento no sentido horário 
{
  for(int i = 0; i < 512; i++)      // incrementa o contador i de 0 a 511 - uma volta
  
    for(int j = 0; j < 8; j++)      // incrementa o contador j de 0 a 7 
    {
      PORTB = HOR[j];               // Carrega bytes da Matriz HOR na Porta B 
      delay (atraso_fase);          // Atraso de tempo entre as fases em milisegundos
    }
}
void setup()
{
  DDRB = 0x0F;           // Configura Portas D08,D09,D10 e D11 como saída 
  PORTB = 0x00;          // Reset dos bits da Porta B (D08 a D15) 
}
void loop()
{
 Motor_HOR();           // Gira motor no sentido Horário 
 delay (intervalo);     // Atraso em milisegundos 
 Motor_AHO();           // Gira motor no sentido Anti-Horário 
 delay (intervalo);     // Atraso em milisegundos 
}
