//---------------------------------------------------------------------------
#include <windows.h>
#include <stdio.h>
#include <fcntl.h>
#include <io.h>
#include <sys\stat.h>
#include "chessfuncs.h"

//#define _loaded_

typedef struct{
 DWORD mVersion;
 HWND mHwnd;
 BOOL mKeep;
} LOADINFO;

#ifdef _loaded_
extern "C" __declspec(dllexport) void __stdcall LoadDll(LOADINFO *ld)
{
 //---
}
//---------------------------------------------------------------------------

extern "C" __declspec(dllexport) int __stdcall UnloadDLL(int mTimeout)
{
 //---
 return 0;
}
//---------------------------------------------------------------------------
#endif

extern "C" __declspec(dllexport) int __stdcall validmoves(HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause)
{
 char board[65];
 char gfield[3], lastfrom[3], lastto[3];
 int fx, fy;
 char wmoved[4], bmoved[4];
 if(sscanf(data,"%64s %2s %2s %2s %3s %3s", board, gfield, lastfrom, lastto, wmoved, bmoved) != 6)
 {
  sprintf(data, "ERROR: parameters are fucked..");
  return 3;
 }

 lastfrom[0] = toupper(lastfrom[0]) - 65;
 lastfrom[1] = lastfrom[1] - 49;
 lastto[0] = toupper(lastto[0]) - 65;
 lastto[1] = lastto[1] - 49;

 unsigned char valids[30];
 char vc = getvalidmoves(valids, toupper(gfield[0]) - 65, gfield[1] - 49, board, lastfrom, lastto, wmoved, bmoved);

 data[0]=0;
 for(long i=0;i<vc;i++)
  sprintf(data+strlen(data)," %c%c",((int)valids[i]%8)+65,(valids[i]/8)+49);

 return 3;
}
//---------------------------------------------------------------------------

extern "C" __declspec(dllexport) int __stdcall dangermoves(HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause)
{
 char board[65];
 char gfield[3];
 int fx, fy;
 if(sscanf(data,"%64s %2s", board, gfield) != 2)
 {
  sprintf(data, "ERROR: parameters are fucked..");
  return 3;
 }

 fx = toupper(gfield[0]) - 65;
 fy = gfield[1] - 48 - 1;

 char movetox, movetoy, afi;
 char dangers[30], dc = 0;

                       //                                         knights

                        char kmpx[] = {-2, -2, -1, -1,  1, 1,  2, 2};
                        char kmpy[] = {-1,  1, -2,  2, -2, 2, -1, 1};
                        for(char i=0;i<8;i++)
                        {
                         movetox = fx + kmpx[i];
                         movetoy = fy + kmpy[i];
                         afi = (movetoy<<3)+movetox;
                         if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                         { if(tolower(board[afi]) == 'n' && board[afi] != '0')
                           { dangers[dc] = (movetoy*8+movetox); dc++; }
                         }
                        }

                       //               diagonal - bishop/queen/king/pawn
                        char bmpx[] = {-1, -1,  1, 1};
                        char bmpy[] = {-1,  1, -1, 1};
                        for(char i=0;i<4;i++)
                        {
                         bool goon=true;
                         char test=0;
                         movetox = fx;
                         movetoy = fy;
                         while (goon) {
                          movetox += bmpx[i];
                          movetoy += bmpy[i];
                          afi = (movetoy<<3)+movetox;
                          test++;
                          if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                          {
                           char fpiece = tolower(board[afi]);
                            if(fpiece != '0' &&
                               (fpiece == 'q' ||
                                fpiece == 'b' ||
                               (fpiece == 'k' && test == 1) ||
                               (fpiece == 'p' && test == 1 && bmpy[i] == ((board[afi]&32)? 1 : -1))))
                            { dangers[dc] = (movetoy*8+movetox); dc++; }
                            if(fpiece != '0') goon = false;
                          }
                          else goon = false;
                         }
                        }

                       //                      straight - rook/queen/king
                        char rmpx[] = {-1, 1,  0, 0};
                        char rmpy[] = { 0, 0, -1, 1};
                        for(char i=0;i<4;i++)
                        {
                         bool goon=true;
                         char test=0;
                         movetox = fx;
                         movetoy = fy;
                         while (goon) {
                          movetox += rmpx[i];
                          movetoy += rmpy[i];
                          afi = (movetoy<<3)+movetox;
                          test++;
                          if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                          {
                           char fpiece = tolower(board[afi]);
                            if(fpiece != '0' &&
                               (fpiece == 'q' ||
                                fpiece == 'r' ||
                               (fpiece == 'k' && test == 1)))
                            { dangers[dc] = (movetoy*8+movetox); dc++; }
                            if(fpiece != '0') goon = false;
                          }
                          else goon = false;
                         }
                        }

 data[0]=0;
 for(long i=0;i<dc;i++)
  sprintf(data+strlen(data)," %c%c",((int)dangers[i]%8)+65,(dangers[i]/8)+49);

 return 3;
}
//---------------------------------------------------------------------------

extern "C" __declspec(dllexport) int __stdcall gameover(HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause)
{
 char board[65];
 char color[2], lastfrom[3], lastto[3];
 int fx, fy;
 char wmoved[4], bmoved[4];
 if(sscanf(data,"%64s %1s %2s %2s %3s %3s", board, color, lastfrom, lastto, wmoved, bmoved) != 6)
 {
  sprintf(data, "ERROR: parameters are fucked..");
  return 3;
 }

 lastfrom[0] = toupper(lastfrom[0]) - 65;
 lastfrom[1] = lastfrom[1] - 49;
 lastto[0] = toupper(lastto[0]) - 65;
 lastto[1] = lastto[1] - 49;

 char kx=-1,ky=-1;
  for(char i=0;i<8&&kx==-1;i++)
   for(char j=0;j<8&&kx==-1;j++)
    if(board[(i*8 + j)] == ('K'^(tolower(color[0])=='w'?0:32)))
    { kx=j; ky=i; }

 if (kx == -1)
 {
  sprintf(data, "ERR: goddammit!");
  return 3;
 }

 if(ischeck(kx,ky,(tolower(color[0]) == 'w' ? 32 : 0),board))
  sprintf(data, "check");
 else
  sprintf(data, "stale");

  unsigned char valids[30];
  for(char i=0;i<8;i++)
   for(char j=0;j<8;j++)
    if((board[(i*8 + j)]&32) == (tolower(color[0])=='w'?0:32))
     if(getvalidmoves(valids, j, i, board, lastfrom, lastto, wmoved, bmoved) > 0)
     {
      sprintf(data, "fine");
      return 3;
     }
 sprintf(data+strlen(data), "mate");
 return 3;
}
//---------------------------------------------------------------------------

extern "C" __declspec(dllexport) int __stdcall getattackers(HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause)
{
 char board[65];
 char gfield[3];
 int fx, fy;
 if(sscanf(data,"%65s %2s", board, gfield) != 2)
 {
  sprintf(data, "ERROR: parameters are fucked..");
  return 3;
 }

 fx = toupper(gfield[0]) - 65;
 fy = gfield[1] - 48 - 1;

 char opp = (board[(fy*8+fx)]&32) ? 0 : 32;
 char movetox, movetoy, afi;
 char dangers[30], dc = 0;

                       //                                         knights

                        char kmpx[] = {-2, -2, -1, -1,  1, 1,  2, 2};
                        char kmpy[] = {-1,  1, -2,  2, -2, 2, -1, 1};
                        for(char i=0;i<8;i++)
                        {
                         movetox = fx + kmpx[i];
                         movetoy = fy + kmpy[i];
                         afi = (movetoy<<3)+movetox;
                         if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                         { if(tolower(board[afi]) == 'n' && (board[afi]&32) == opp)
                           { dangers[dc] = (movetoy*8+movetox); dc++; }
                         }
                        }

                       //               diagonal - bishop/queen/king/pawn
                        char bmpx[] = {-1, -1,  1, 1};
                        char bmpy[] = {-1,  1, -1, 1};
                        for(char i=0;i<4;i++)
                        {
                         bool goon=true;
                         char test=0;
                         movetox = fx;
                         movetoy = fy;
                         while (goon) {
                          movetox += bmpx[i];
                          movetoy += bmpy[i];
                          afi = (movetoy<<3)+movetox;
                          test++;
                          if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                          {
                           char fpiece = tolower(board[afi]);
                            if(fpiece != '0' && (board[afi]&32) == opp &&
                               (fpiece == 'q' ||
                                fpiece == 'b' ||
                               (fpiece == 'k' && test == 1) ||
                               (fpiece == 'p' && test == 1 && bmpy[i] == ((board[afi]&32)? 1 : -1))))
                            { dangers[dc] = (movetoy*8+movetox); dc++; }
                            if(fpiece != '0') goon = false;
                          }
                          else goon = false;
                         }
                        }

                       //                      straight - rook/queen/king
                        char rmpx[] = {-1, 1,  0, 0};
                        char rmpy[] = { 0, 0, -1, 1};
                        for(char i=0;i<4;i++)
                        {
                         bool goon=true;
                         char test=0;
                         movetox = fx;
                         movetoy = fy;
                         while (goon) {
                          movetox += rmpx[i];
                          movetoy += rmpy[i];
                          afi = (movetoy<<3)+movetox;
                          test++;
                          if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                          {
                           char fpiece = tolower(board[afi]);
                            if(fpiece != '0' && (board[afi]&32) == opp &&
                               (fpiece == 'q' ||
                                fpiece == 'r' ||
                               (fpiece == 'k' && test == 1)))
                            { dangers[dc] = (movetoy*8+movetox); dc++; }
                            if(fpiece != '0') goon = false;
                          }
                          else goon = false;
                         }
                        }

 data[0]=0;
 for(long i=0;i<dc;i++)
  sprintf(data+strlen(data)," %c%c",((int)dangers[i]%8)+65,(dangers[i]/8)+49);

 return 3;
}
//---------------------------------------------------------------------------

extern "C" __declspec(dllexport) int __stdcall getallvalidmoves(HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause)
{
 char board[65];
 char turn[2], lastfrom[3], lastto[3];
 char wmoved[4], bmoved[4];
 if(sscanf(data,"%64s %1s %2s %2s %3s %3s", board, turn, lastfrom, lastto, wmoved, bmoved) != 6)
 {
  sprintf(data, "ERROR: parameters are fucked..");
  return 3;
 }

 lastfrom[0] = toupper(lastfrom[0]) - 65;
 lastfrom[1] = lastfrom[1] - 49;
 lastto[0] = toupper(lastto[0]) - 65;
 lastto[1] = lastto[1] - 49;
 turn[0] = (tolower(turn[0])=='w')?0:32;

 unsigned char allvalids[200], valids[30];
 char avc=0;

 for(long i=0;i<64;i++)
 {
  if((board[i]&32) == turn[0]) {
   char vc = getvalidmoves(valids, (i % 8), (int) i / 8, board, lastfrom, lastto, wmoved, bmoved);
   for(long j=0;j<vc;j++)
   {
    allvalids[avc]=i;  avc++;
    allvalids[avc]=valids[j]; avc++;
   }
  }
 }

 data[0]=0;
 for(long i=0;i<avc;i+=2)
  sprintf(data+strlen(data),"%c%c-%c%c", ((int)allvalids[i]%8)+65,(allvalids[i]/8)+49,((int)allvalids[i+1]%8)+65,(allvalids[i+1]/8)+49);

 return 3;
}
//---------------------------------------------------------------------------

extern "C" __declspec(dllexport) int __stdcall getposrating(HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause)
{
 char board[65];
 char turn[2], lastfrom[3], lastto[3];
 char wmoved[4], bmoved[4];
 if(sscanf(data,"%64s %1s %2s %2s %3s %3s", board, turn, lastfrom, lastto, wmoved, bmoved) != 6)
 {
  sprintf(data, "ERROR: parameters are fucked..");
  return 3;
 }
 data[0]=0;

 lastfrom[0] = toupper(lastfrom[0]) - 65;
 lastfrom[1] = lastfrom[1] - 49;
 lastto[0] = toupper(lastto[0]) - 65;
 lastto[1] = lastto[1] - 49;
 turn[0] = tolower(turn[0]);

 long ratingw, ratingb;
 rateposition(&ratingw, &ratingb, board, turn, wmoved, bmoved, true);

 sprintf(data+strlen(data)," %d %d", ratingw, ratingb);
 return 3;
}
//---------------------------------------------------------------------------

extern "C" __declspec(dllexport) int __stdcall tblit(HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause)
{
 char f1[100], f2[100];
 int perc;
 if (sscanf(data, "%s %s %d", f1, f2, &perc) != 3) {
   sprintf(data, "ERR: insufficient parameters");
   return 3;
 }
 if (perc<0) perc=0;
 else if (perc>100) perc=100;

 int fh=open(f1,O_RDONLY|O_BINARY);
 if (fh == -1) {
   sprintf(data, "ERR: unable to open file '%s'...", f1);
   return 3;
 }
 int len=lseek(fh,0,SEEK_END);
 char *file1=(char*)malloc(len);
 lseek(fh,0,SEEK_SET);
 read(fh, file1, len);
 close(fh);

 if (!(file1[0] == 'B' && file1[1] == 'M')) {
   free(file1);
   sprintf(data, "ERR: file '%s' is not a Bitmap...", f1);
   return 3;
 }

 fh=open(f2,O_RDONLY|O_BINARY);
 if (fh == -1) {
   free(file1);
   sprintf(data, "ERR: unable to open file '%s'...", f2);
   return 3;
 }
 len=lseek(fh,0,SEEK_END);
 char *file2=(char*)malloc(len);
 lseek(fh,0,SEEK_SET);
 read(fh, file2, len);
 close(fh);

 if (!(file2[0] == 'B' && file2[1] == 'M')) {
   free(file1);
   free(file2);
   sprintf(data, "ERR: file '%s' is not a Bitmap...", f2);
   return 3;
 }

 if (((long*)&file1[18])[0] != ((long*)&file2[18])[0] ||
     ((long*)&file1[22])[0] != ((long*)&file2[22])[0] ||
     ((short*)&file1[28])[0] != ((short*)&file2[28])[0] ) {
   free(file1);
   free(file2);
   sprintf(data, "ERR: Bitmap-dimensions/bitdepth don't match or corrupt files...");
   return 3;
 }

 if (((short*)&file1[28])[0] == 24 || ((short*)&file1[28])[0] == 32) {
   unsigned char *p1=file1+54, *p2=file2+54;
   unsigned char *maxp=file1+len;
   while (p1<maxp) {
     p1[0]=(p1[0]*(100-perc)+p2[0]*perc)/100;
     p1++;
     p2++;
   }
 }
 else if (((short*)&file1[28])[0] == 16) {
   unsigned short *p1=(unsigned short*)file1+27, *p2=(unsigned short*)file2+27;
   unsigned short *maxp=(unsigned short*)file1+(len>>1);
   unsigned char r, g, b;
   while (p1<maxp) {
     r=((p1[0]>>10)*(100-perc)+(p2[0]>>10)*perc)/100;
     g=(((p1[0]>>5)&31)*(100-perc)+((p2[0]>>5)&31)*perc)/100;
     b=((p1[0]&31)*(100-perc)+(p2[0]&31)*perc)/100;
     p1[0]=((r&63)<<10)+((g&31)<<5)+(b&31);
     p1++;
     p2++;
   }
 }
 else {
   free(file1);
   free(file2);
   sprintf(data, "ERR: unsupported bitdepth");
   return 3;
 }

 fh=open("tblit.bmp",O_CREAT|O_TRUNC|O_BINARY|O_WRONLY, S_IREAD|S_IWRITE);
 write(fh,file1,len);
 close(fh);

 free(file1);
 free(file2);
 sprintf(data, "OK: .");
 return 3;
}
//---------------------------------------------------------------------------


