#pragma check_stack(off)
#pragma comment(linker,"/OPT:NOWIN98")

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>

extern "C" int __stdcall WINAPI get(HWND mWnd,HWND aWnd,char *data,char *parm,BOOL lisa,BOOL rinna) {
 char *fr = strtok(data," ");
 char *fw = strtok(NULL,"\0");
 FILE *f,*g;
 f = fopen(fr,"rb+");
 if (!f) {
  strcpy(data,"E_FILE_A");
  return 3;
 }
 g = fopen(fw,"wb+");
 if (!g) {
  fclose(f);
  strcpy(data,"E_FILE_B");
  return 3;
 }
 int i;
 strcpy(data,"S_OK");
 char *buffer = new char[2048];
 try {
  while(!feof(f)) {
   i = fseek(f,3L,SEEK_CUR);
   i = fread(buffer,sizeof(char),2045,f);
   fwrite(buffer,sizeof(char),i,g);
  }
 }
 catch (...) {
  strcpy(data,"E_FREAD");
 }
 fclose(f);
 fclose(g);
 delete[] buffer;
 return 3;
}
