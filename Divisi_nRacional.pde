void setup () {
   size(400, 600);
   textFont(createFont("Georgia", 36));
}

float num = 2;
float den = 3;
boolean div = false;
boolean divMuestra = true;
byte edit = 0;
char letter;
String numStr = "2";
String denStr = "3";
char[] chNum;
char[] chDen;

void draw() {
  background(0);
  fill(240);
  stroke(160);
  textSize(20);
  text("División racional:", 20, 40);
  line(200, 70, 200, 105);
  line(200, 105, 360, 105);
  textAlign(RIGHT);
  text(numStr, 180, 90);
  if (edit == 1) if (millis()%1000 > 500) line(182, 75, 182, 94);
  textAlign(LEFT);
  text(denStr, 220, 90);
  if (edit == 2) if (millis()%1000 > 500) line(223+textWidth(denStr), 75, 223+textWidth(denStr), 94);
  if (330 <= mouseX && mouseX <= 360 && 25 <= mouseY && mouseY <= 55) {
     fill(150, 0, 150, 70);
     div = true;
  } else {
     fill(10);
     div = false;
  }
  rect(330, 25, 30, 30);
  if (divMuestra) Dividir(num, den);
}

void Dividir(float num, float den) {
   // Voy a asumir que den y num son naturales.
   int[] b = new int[int(den)];  // Vector de restos (sin añadirles la bajada siguiente) para calcular el período.
   int[] r = new int[int(den)];  // Vector de restos con la bajada siguiente.
   byte[] c = new byte[int(den)+10];  // Vector con cada cifra del cociente. El tamaño es relativo según las cifras antes de la coma. Pongo un margen de 10; el programa no aspira a más.
   boolean periodo = false;
   boolean decimales = false;
   int den0;
   int num0;
   byte rn = byte(numStr.length());  // rn recorre el numerador y lleva el índice de las bajadas, hasta que lo recorra por completo. Entonces empiezan los decimales.
   String op;   // String con las cifras que se van cogiendo del numerador.
   byte m = 0;  // Variable con el número de cifras antes de la coma del cociente, que se utiliza en caso de haberlas. El tamaño que alcanza esta variable (y que se le suma
   // al tamaño del vector c, en lugar del 10 que tengo puesto) puede calcularse fácilmente de antemano, y entonces definir c. No es necesario para lo que quiero.
   fill(240);
   // Empiezo a dividir:
   if (numStr.length() > denStr.length()) {
     rn = byte(denStr.length());
     op = numStr.substring(0,denStr.length());
     if (int(op) < int(den)) {
       rn++;
     }
     op = numStr.substring(0,rn);
     num0 = int(op);
   } else {
     num0 = int(num);
   }
   den0 = int(den);  // El denominador lo podría dividir en cadenas más pequeñas, pero no me merece la pena meterme aquí para el propósito del programa.
   c[0] = byte(num0/den0);
   text(c[0], 220, 130);
   if (rn < numStr.length()) {   // Si rn no ha llegado a su máximo, avanza.
     num0 = int(str(num0-den0*c[0]) + numStr.charAt(rn));
     rn++;
   } else {                      // Si no, empiezan los decimales.
     b[0] = num0-den0*c[0];
     decimales = true;
     text("'", 230, 130);
   }
   textAlign(RIGHT);
   if (decimales) {              // Cuento los restos si empiezan los decimales.
     r[0] = b[0] * 10;
     text(r[0], 180, 120);
   } else {
     text(str(num0)+numStr.substring(rn), 180, 120); 
   }
   textAlign(LEFT);
   
   // Bien. Tiene que haber un bucle ANTES de la coma y otro DESPUÉS de la coma. La coma solo se utiliza en el cociente si se acaba rn, que es cuando se multiplica el
   // resto por 10. Puede que haga a este programa evolucionar para que divida de esta forma números periódicos. Pero primero voy a hacerlo así. El programa solo se
   // acaba con el bucle que va tras la coma, así que el bucle de en medio me lo podría saltar dadas determinadas circunstancias.
   
   while (rn < numStr.length()) {
     m++;
     c[m] = byte(num0/den0);  // Repito parte del proceso del principio, con rn.
     text(c[m], 220 + 15*(m%10), 130 + 25*((m - m%10)/10));
     num0 = int(str(num0-den0*c[m]) + numStr.charAt(rn));
     rn++;
     textAlign(RIGHT);
     text(str(num0)+numStr.substring(rn), 180, 120+30*m); 
     textAlign(LEFT);
   }
   if (!decimales) {
     if (rn == numStr.length()) {
       m++;
       c[m] = byte(num0/den0);
       text(c[m], 220 + 15*(m%10), 130 + 25*((m - m%10)/10));
       b[0] = num0-den0*c[m];
       text("'", 230+15*m, 130);
       textAlign(RIGHT);
       r[0] = b[0] * 10;
       text(r[0], 180, 120+30*m);
       textAlign(LEFT);
     }
   }
   for (int n = 1; n < den0; n++) {  // Empieza el siguiente bucle. Como el propósito es que el programa marque siempre el período, es imposible que termine en un paso.
     if (!periodo) {  // Periodo se activa cuando encuentra un periodo, por lo que para el bucle. Es una condición de salida.
       c[n+m] = byte(r[n-1]/den0);
       text(c[n+m], 220 + 15*((n+m)%10), 130 + 25*(((m+n) - (m+n)%10)/10));
       b[n] = r[n-1] - den0*c[n+m];
       
       /*
       if (c[n] != 0) {
         text(c[n], 220 + 15*n, 130);
       } else {
         boolean comaAnt = false;
         for (int m = 0; m < n; m++) {
           if (c[m] == 0) comaAnt = true;
         }
         if (comaAnt) {
           text("0", 220 + 15*n, 130);
         } else {
           text("0'", 220 + 15*n, 130); 
         }
       }
       */
       
       for (int k = 0; k < n; k++) {        // n: posición actual.
         if (!periodo) {                    // m: cifras antes de la coma en el cociente.
           if (b[n] == b[k]) {              // k: cifra en la que empieza el período, que va de ella hasta n.
             if (m+k+1 < 10 && n+m < 10) {
               line(221 +15*(m+k+1), 135, 221+15*(n+m)+8, 135);
             } else {
               if (((m+k+1)-(m+k+1)%10)/10 == 0) {
                 line(221 +15*((m+k+1)%10), 135 + 25*(((m+k+1)-(m+k+1)%10)/10), 221+15*9+8, 135 + 25*(((m+k+1)-(m+k+1)%10)/10));
               }
               if ((((m+n)-(m+n)%10)/10) - (((m+k+1)-(m+k+1)%10)/10) > 2) { 
                 for (byte l = byte((((m+k+1)-(m+k+1)%10)/10)+1); l < byte(((m+n)-(m+n)%10)/10); l++) {
                   line(221, 135 + 25*l, 221+158-15, 135 + 25*l); 
                 }
               }
               line(221, 135+25*(((m+n)-(m+n)%10)/10), 221+15*((m+n)%10)+8, 135+25*(((m+n)-(m+n)%10)/10));
             }
             periodo = true;
           }
         }
       }
       r[n] = b[n] * 10;
       textAlign(RIGHT);
       if (!periodo) {
         text(r[n], 180, 120 +30*(n+m));
       } else {
         text(b[n], 180, 120 +30*(n+m));  // si m+n mayor que 16, se empieza a perder.
       }
       textAlign(LEFT);
     }
   }
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    if (div) {
      edit = 0;
      if (numStr.charAt(numStr.length()-1) == '\'') {
        chNum = new char[numStr.length()-1];
        for (int i = 0; i < numStr.length()-1; i++) chNum[i] = numStr.charAt(i);
        numStr = new String(chNum);
      }
      if (denStr.charAt(denStr.length()-1) == '\'') {
        chDen = new char[denStr.length()-1];
        for (int i = 0; i < denStr.length()-1; i++) chDen[i] = denStr.charAt(i);
        denStr = new String(chDen);
      }
      chDen = new char[denStr.length()-1];
      for (int i = 0; i < denStr.length()-1; i++) if (denStr.charAt(i) == '\'') {
        for (int j = 1; j < denStr.length() - j; j++) {
          byte b = 0;
          for (byte k = 0; k < denStr.length()-1; k++) if (denStr.charAt(k) == '\'') b = k;
          for (byte k = 0; k < denStr.length()-1; k++) {
            if (k < b) {
              chDen[k] = denStr.charAt(k); 
            } else {
              chDen[k] = denStr.charAt(k+1); 
            }
          }
          
          
          //num = num*10;
        }
        denStr = new String(chDen);
      }
      
      
      den = float(denStr);
      num = float(numStr);
      if (den == 0) den = 1;
      divMuestra = true;
    } else {
      if (30 <= mouseX && mouseX <= 200 && 70 <= mouseY && mouseY <= 105) {
        edit = 1;
      } else if (200 <= mouseX && mouseX <= 370 && 70 <= mouseY && mouseY <= 105) {
        edit = 2;
      } else {
        edit = 0; 
      }
    }
  }
}

void keyPressed() {
  if (edit == 1 || edit == 2) {
    divMuestra = false;
    if (48 <= key && key <= 57) {
      if (edit == 1) {
        numStr = numStr + key; 
      } else {
        denStr = denStr + key;
      }
    }
    letter = '\'';
    if (key == 44 || key == 46 ||key == 39) {
      divMuestra = false;
      if (edit == 1) {
        byte c = 0;
        for (int i = 0; i < numStr.length(); i++) if (numStr.charAt(i) == '\'' ) c++;
        if (c == 0) numStr = numStr + letter;
      } else {
        byte c = 0;
        for (int i = 0; i < denStr.length(); i++) if (denStr.charAt(i) == '\'' ) c++;
        if (c == 0) denStr = denStr + letter;
      }
    }
    if (key == BACKSPACE || key == 127) {
      divMuestra = false;
      if (edit == 1) {
        if (numStr.length() > 0) {
          chNum = new char[numStr.length()-1];
          for (int i = 0; i < numStr.length()-1; i++) chNum[i] = numStr.charAt(i);
          numStr = new String(chNum);
        }
      } else {
        if (denStr.length() > 0) {
          chDen = new char[denStr.length()-1];
          for (int i = 0; i < denStr.length()-1; i++) chDen[i] = denStr.charAt(i);
          denStr = new String(chDen);
        }
      }
    }
  }
}


/*
float[] Simplificar(float num, float dem) {
  float[] sal = {num, dem};
  if (num == 0) return sal;
  float top = 0;
  if (abs(num) < abs(dem)) {
    top = abs(dem);
  } else {
    top = abs(num);
  }
  float num_r = num;
  float dem_r = dem;
  for (int i = 2; i <= sqrt(top); i++) {
    if (num_r % i == 0) {
      if (dem_r % i == 0) {
        num_r = num_r/i;
        dem_r = dem_r/i;
        i = 1;
      }
    }
  }
  if (num_r < 0 & dem_r < 0) {
   num_r = abs(num_r);
   dem_r = abs(dem_r); 
  }
  sal[0] = num_r;
  sal[1] = dem_r;
 return sal; 
}
*/