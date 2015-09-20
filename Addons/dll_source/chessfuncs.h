#include <stdio.h>
#include <io.h>
#include <fcntl.h>
#include <sys/stat.h>

//#define DEBUG

bool ischeck(char fx, char fy, unsigned char opp, char* board)
{
 char movetox, movetoy, afi;
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
                           { return true; }
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
                            { return true; }
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
                            { return true; }
                            if(fpiece != '0') goon = false;
                          }
                          else goon = false;
                         }
                        }
 return false;
}
//---------------------------------------------------------------------------

char getvalidmoves(unsigned char* valids, char fx, char fy, char* board, char* lastfrom, char* lastto, char* wmoved, char* bmoved)
{
 char vc = 0;
 char ownpiece=board[((fy<<3)+fx)];
 unsigned char owncolor = (ownpiece&32), ecolor=(owncolor == 0 ? 32 : 0);
 ownpiece=tolower(ownpiece);

 char movetox, movetoy;
 char validdir = (owncolor == 0) ? 1 : -1;
 char afi;

 switch(ownpiece)
 {
                       //                                  empty field..
  case '0': break;
                       //                                           pawn
  case 'p':            // two steps at beginning
                       if((owncolor == 0 && fy == 1) || (owncolor == 32 && fy == 6))
                       {
                        movetox = fx;
                        movetoy = fy + 2*validdir;
                        afi = (movetoy<<3)+movetox;
                        if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                        { if(board[(((movetoy - validdir)<<3)+movetox)] == '0' && board[afi] == '0')
                          { valids[vc] = afi; vc++; }
                        }
                       }

                       // one step
                       movetox = fx;
                       movetoy = fy + validdir;
                       afi = (movetoy<<3)+movetox;
                       if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                       { if(board[afi] == '0')
                         { valids[vc] = afi; vc++; }
                       }

                       // capturing
                       movetoy = fy + validdir;
                       movetox = fx - 1;
                       afi = (movetoy<<3)+movetox;
                       if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                       { if(board[afi]!='0' && (board[afi]&32) == ecolor)
                         { valids[vc] = afi; vc++; }
                       }
                       movetox = fx + 1;
                       afi = (movetoy<<3)+movetox;
                       if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                       { if(board[afi]!='0' && (board[afi]&32) == ecolor)
                         { valids[vc] = afi; vc++; }
                       }

                       // capturing en passant
                       movetoy = fy + validdir;
                       movetox = fx - 1;
                       afi = (movetoy<<3)+movetox;
                       if(lastfrom[0] == movetox && lastfrom[1] == movetoy + validdir &&
                          lastto[0] == movetox && lastto[1] == fy && tolower(board[((lastto[1]<<3)+lastto[0])]) == 'p' && board[afi] == '0')
                       { if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                         { valids[vc] = afi; vc++; }
                       }
                       movetox = fx + 1;
                       afi = (movetoy<<3)+movetox;
                       if(lastfrom[0] == movetox && lastfrom[1] == movetoy + validdir &&
                          lastto[0] == movetox && lastto[1] == fy && tolower(board[((lastto[1]<<3)+lastto[0])]) == 'p' && board[afi] == '0')
                       { if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                         { valids[vc] = afi; vc++; }
                       }
                       break;

                       //                                         knight
  case 'n':            {
                        char kmpx[] = {-2, -2, -1, -1,  1, 1,  2, 2};
                        char kmpy[] = {-1,  1, -2,  2, -2, 2, -1, 1};
                        for(char i=0;i<8;i++)
                        {
                         movetox = fx + kmpx[i];
                         movetoy = fy + kmpy[i];
                         afi = (movetoy<<3)+movetox;
                         if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                         { if(board[afi] == '0' || (board[afi]&32) != owncolor)
                           { valids[vc] = afi; vc++; }
                         }
                        }
                       }
                       break;

                       //                                         bishop
  case 'b':            {
                        char bmpx[] = {-1, -1,  1, 1};
                        char bmpy[] = {-1,  1, -1, 1};
                        for(char i=0;i<4;i++)
                        {
                         bool goon=true;
                         movetox = fx;
                         movetoy = fy;
                         while (goon) {
                          movetox += bmpx[i];
                          movetoy += bmpy[i];
                          afi = (movetoy<<3)+movetox;
                          if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                          { if(board[afi] == '0' || (board[afi]&32) != owncolor)
                            { valids[vc] = afi; vc++; }
                            if(board[afi] != '0') goon = false;
                          }
                          else goon = false;
                         }
                        }
                       }
                       break;

                       //                                           rook
  case 'r':            {
                        char rmpx[] = {-1, 1,  0, 0};
                        char rmpy[] = { 0, 0, -1, 1};
                        for(char i=0;i<4;i++)
                        {
                         bool goon=true;
                         movetox = fx;
                         movetoy = fy;
                         while (goon) {
                          movetox += rmpx[i];
                          movetoy += rmpy[i];
                          afi = (movetoy<<3)+movetox;
                          if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                          { if(board[afi] == '0' || (board[afi]&32) != owncolor)
                            { valids[vc] = afi; vc++; }
                            if(board[afi] != '0') goon = false;
                          }
                          else goon = false;
                         }
                        }
                       }
                       break;

                       //                                          queen
  case 'q':            {
                        char qmpx[] = {-1, 1,  0, 0, -1, -1,  1, 1};
                        char qmpy[] = { 0, 0, -1, 1, -1,  1, -1, 1};
                        for(char i=0;i<8;i++)
                        {
                         bool goon=true;
                         movetox = fx;
                         movetoy = fy;
                         while (goon) {
                          movetox += qmpx[i];
                          movetoy += qmpy[i];
                          afi = (movetoy<<3)+movetox;
                          if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                          { if(board[afi] == '0' || (board[afi]&32) != owncolor)
                            { valids[vc] = afi; vc++; }
                            if(board[afi] != '0') goon = false;
                          }
                          else goon = false;
                         }
                        }
                       }
                       break;

                       //                                           king
  case 'k':            {
                        char kmpx[] = {-1, 1,  0, 0, -1, -1,  1, 1};
                        char kmpy[] = { 0, 0, -1, 1, -1,  1, -1, 1};
                        for(char i=0;i<8;i++)
                        {
                         movetox = fx + kmpx[i];
                         movetoy = fy + kmpy[i];
                         afi = (movetoy<<3)+movetox;
                         if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                         { if(board[afi] == '0' || (board[afi]&32) != owncolor)
                           { valids[vc] = afi; vc++; }
                         }
                        }

                        // castling
                        if(owncolor == 0 && wmoved[0] != '1' && (wmoved[1] != '1' || wmoved[2] != '1') && !ischeck(fx,fy,32,board))
                        { if(board[1] == '0' && // (0 * 8 + 1) (B1)
                             board[2] == '0' && // (0 * 8 + 2) (C1)
                             board[3] == '0' && // (0 * 8 + 3) (D1)
                             wmoved[1] != '1' && board[0] == 'R')
                          { if(!ischeck(2,0,32,board) && // no check on C1
                               !ischeck(3,0,32,board))   // no check on D1
                            { valids[vc] = 2; vc++; } // C1 is valid
                          }

                          if(board[5] == '0' && // (0 * 8 + 5) (F1)
                             board[6] == '0' && // (0 * 8 + 6) (G1)
                             wmoved[2] != '1' && board[7] == 'R')
                          { if(!ischeck(5,0,32,board) && // no check on F1
                               !ischeck(6,0,32,board))   // no check on G1
                            { valids[vc] = 6; vc++; } // G1 is valid
                          }
                        }
                        else if(owncolor == 32 &&  bmoved[0] != '1' && (bmoved[1] != '1' || bmoved[2] != '1') && !ischeck(fx,fy,0,board))
                        { if(board[57] == '0' && // (7 * 8 + 1) (B8)
                             board[58] == '0' && // (7 * 8 + 2) (C8)
                             board[59] == '0' && // (7 * 8 + 3) (D8)
                             bmoved[1] != '1' && board[56] == 'r')
                          { if(!ischeck(2,7,0,board) && // no check on C8
                               !ischeck(3,7,0,board))   // no check on D8
                            { valids[vc] = 58; vc++; } // C8 is valid
                          }

                          if(board[61] == '0' && // (7 * 8 + 5) (F8)
                             board[62] == '0' && // (7 * 8 + 6) (G8)
                             bmoved[2] != '1' && board[63] == 'r')
                          { if(!ischeck(5,7,0,board) && // no check on F8
                               !ischeck(6,7,0,board))   // no check on G8
                            { valids[vc] = 62; vc++; } // G8 is valid
                          }
                        }
                       }
                       break;

                       //                                         fuckup
  default:             return 0;
 }

 char kx=-1, ky=-1;
 if(ownpiece != 'k')
 {
  for(char i=0;i<64;i++)
   if((board[i]&32) == owncolor && tolower(board[i]) == 'k')
    { ky=(i>>3); kx=i&7; i=65; }
 }

 char save[64];
 board[((fy<<3) + fx)] = '0';
 for(char i=vc-1;i>=0;i--)
 {
  memcpy(save, board, 64);
  if(ownpiece == 'p')
  {
   if(board[valids[i]] == '0' && (valids[i]&7) != fx)
   {
    unsigned captppos=(valids[i]+(owncolor==0?-8:8));
    board[captppos] = '0';
   }
  }
  board[valids[i]] = (owncolor==0 ? toupper(ownpiece) : ownpiece);
  if (ownpiece == 'k') { kx = valids[i]&7; ky = (valids[i]>>3); }
  if(ischeck(kx,ky,ecolor,board))
  { memmove(&valids[i], &valids[i+1], vc-i-1); vc--; }
  memcpy(board, save, 64);
 }

 board[((fy<<3) + fx)] = (owncolor==0 ? toupper(ownpiece) : ownpiece);

 return vc;
}
//---------------------------------------------------------------------------

long worth_ind(unsigned char p)
{
 switch(p)
 {
  case 'p':
  case 'P': return 1;
  case 'n':
  case 'N': return 2;
  case 'b':
  case 'B': return 3;
  case 'r':
  case 'R': return 4;
  case 'q':
  case 'Q': return 5;
  case 'k':
  case 'K': return 6;
  default: return 0;
 }
}
//---------------------------------------------------------------------------

void rateposition(long* ratingw, long* ratingb, char* board, char* turn, char* wmoved, char* bmoved, bool debug)
{
 unsigned char boardw[2][64]={0};
 unsigned long boardheavy[2][64]={0};
 unsigned char worth[7]={0,10,30,35,50,90,0};
 unsigned char fieldrating[64]={ 1,1,1,1,1,1,1,1,
                                 1,2,2,2,2,2,2,1,
                                 1,2,2,2,2,2,2,1,
                                 1,3,3,3,3,3,3,1,
                                 1,3,3,3,3,3,3,1,
                                 1,2,2,2,2,2,2,1,
                                 1,2,2,2,2,2,2,1,
                                 1,1,1,1,1,1,1,1 };

 for(long i=0;i<64;i++)
 {
  char fx=(i&7), fy=(i>>3);

  char owncolor = (board[i]&32);
  char bin=(owncolor==0?0:1);
  char ownpiece = tolower(board[i]);

  char movetox, movetoy;
  char validdir = (owncolor == 0) ? 1 : -1;
  char piecew = worth_ind(ownpiece);

  if (ownpiece!='0')
   boardheavy[bin][i]+=worth[piecew];

  char pmoves=0, afi;

  switch(piecew)
  {
                        //                                  empty field..
   case 0:              break;
                        //                                           pawn
   case 1:              // two steps at beginning
                        if((owncolor == 0 && fy == 1) || (owncolor == 32 && fy == 6))
                        {
                         movetox = fx;
                         movetoy = fy + 2*validdir;
                         afi = (movetoy<<3)+movetox;
                         if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                         { if(board[(((movetoy - validdir)<<3)+movetox)] == '0' && board[afi] == '0')
                           {
                           }
                         }
                        }

                        // one step
                        movetox = fx;
                        movetoy = fy + validdir;
                        afi = (movetoy<<3)+movetox;
                        if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                        { if(board[afi] == '0')
                          {
                          }
                        }

                        movetoy = fy + validdir;
                        movetox = fx - 1;
                        afi = (movetoy<<3)+movetox;
                        if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                        {
                         boardw[bin][afi] ++;
                         boardheavy[bin][afi] += worth[piecew];
                        }

                        movetox = fx + 1;
                        afi = (movetoy<<3)+movetox;
                        if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                        {
                         boardw[bin][afi] ++;
                         boardheavy[bin][afi] += worth[piecew];
                        }
                        break;

                        //                                         knight
   case 2:              {
                         char kmpx[] = {-2, -2, -1, -1,  1, 1,  2, 2};
                         char kmpy[] = {-1,  1, -2,  2, -2, 2, -1, 1};
                         for(char i=0;i<8;i++)
                         {
                          movetox = fx + kmpx[i];
                          movetoy = fy + kmpy[i];
                          afi = (movetoy<<3)+movetox;
                          if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                          {
                           boardw[bin][afi] ++;
                           boardheavy[bin][afi] += worth[piecew];
                           if(board[afi] == '0')
                            pmoves++;
                          }
                         }
                         if(pmoves<3)
                         {
                          if(!bin)
                           ratingw[0]-=(300-100*pmoves);
                          else
                           ratingb[0]-=(300-100*pmoves);
                         }
                        }
                        break;

                        //                                         bishop
   case 3:              {
                         char bmpx[] = {-1, -1,  1, 1};
                         char bmpy[] = {-1,  1, -1, 1};
                         for(char i=0;i<4;i++)
                         {
                          bool goon=true;
                          movetox = fx;
                          movetoy = fy;
                          while (goon) {
                           movetox += bmpx[i];
                           movetoy += bmpy[i];
                           afi = (movetoy<<3)+movetox;
                           if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                           {
                            boardw[bin][afi] ++;
                            boardheavy[bin][afi] += worth[piecew];
                            if(board[afi] == '0')
                             pmoves++;
                            else goon=false;
                           }
                           else goon = false;
                          }
                         }
                         if(pmoves<=3)
                         {
                          if(!bin)
                           ratingw[0]-=(500-100*pmoves);
                          else
                           ratingb[0]-=(500-100*pmoves);
                         }
                        }
                        break;

                        //                                           rook
   case 4:              {
                         char rmpx[] = {-1, 1,  0, 0};
                         char rmpy[] = { 0, 0, -1, 1};
                         for(char i=0;i<4;i++)
                         {
                          bool goon=true;
                          movetox = fx;
                          movetoy = fy;
                          while (goon) {
                           movetox += rmpx[i];
                           movetoy += rmpy[i];
                           afi = (movetoy<<3)+movetox;
                           if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                           {
                            boardw[bin][afi] ++;
                            boardheavy[bin][afi] += worth[piecew];
                            if(board[afi] == '0')
                             pmoves++;
                            else goon=false;
                           }
                           else goon = false;
                          }
                         }
                         if(pmoves<=3)
                         {
                          if(!bin)
                           ratingw[0]-=(400-100*pmoves);
                          else
                           ratingb[0]-=(400-100*pmoves);
                         }
                        }
                        break;

                        //                                          queen
   case 5:              {
                         char qmpx[] = {-1, 1,  0, 0, -1, -1,  1, 1};
                         char qmpy[] = { 0, 0, -1, 1, -1,  1, -1, 1};
                         for(char i=0;i<8;i++)
                         {
                          bool goon=true;
                          movetox = fx;
                          movetoy = fy;
                          while (goon) {
                           movetox += qmpx[i];
                           movetoy += qmpy[i];
                           afi = (movetoy<<3)+movetox;
                           if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                           {
                            boardw[bin][afi] ++;
                            boardheavy[bin][afi] += worth[piecew];
                            if(board[afi] == '0')
                             pmoves++;
                            else goon=false;
                           }
                           else goon = false;
                          }
                         }
                         if(pmoves<=3)
                         {
                          if(!bin)
                           ratingw[0]-=(500-100*pmoves);
                          else
                           ratingb[0]-=(500-100*pmoves);
                         }
                        }
                        break;

                        //                                           king
   case 6:              {
                         char kmpx[] = {-1, 1,  0, 0, -1, -1,  1, 1};
                         char kmpy[] = { 0, 0, -1, 1, -1,  1, -1, 1};
                         for(char i=0;i<8;i++)
                         {
                          movetox = fx + kmpx[i];
                          movetoy = fy + kmpy[i];
                          afi = (movetoy<<3)+movetox;
                          if(movetox >= 0 && movetox < 8 && movetoy >= 0 && movetoy < 8)
                          {
                           boardw[bin][afi] ++;
                           boardheavy[bin][afi] += worth[piecew];
                           if(board[afi] == '0')
                            pmoves++;
                          }
                         }

                         if(pmoves>3)
                         {
                          if(!bin)
                           ratingw[0]-=300;
                          else
                           ratingb[0]-=300;
                         }
                        }
                        break;

                        //                                         fuckup
   default:             break;
  }
 }

 long fn;
 if(debug)
 {
  fn=open("sitstats.txt",O_RDWR|O_CREAT|O_TRUNC|O_TEXT,S_IWRITE|S_IREAD);
  char line[100]={0};
  for(long i=7;i>=0;i--)
  {
   for(long j=0;j<8;j++)
    sprintf(line+strlen(line),"%d ",boardw[0][(i<<3)+j]);

   sprintf(line+strlen(line), " -  ");
   for(long j=0;j<8;j++)
    sprintf(line+strlen(line),"%03d ",boardheavy[0][(i<<3)+j]);

   sprintf(line+strlen(line),"\n");
   write(fn,line,strlen(line));
   line[0]=0;
  }

  write(fn,"\n\n",2);
  line[0]=0;
  for(long i=7;i>=0;i--)
  {
   for(long j=0;j<8;j++)
    sprintf(line+strlen(line),"%d ",boardw[0][(i<<3)+j]);

   sprintf(line+strlen(line), " -  ");
   for(long j=0;j<8;j++)
    sprintf(line+strlen(line),"%03d ",boardheavy[0][(i<<3)+j]);

   sprintf(line+strlen(line),"\n");
   write(fn,line,strlen(line));
   line[0]=0;
  }
 }

 ratingw[0]=(turn[0] == 'w' ? 250 : 0);
 ratingb[0]=(turn[0] == 'b' ? 250 : 0);
 for(long i=0;i<64;i++)
 {
  unsigned char t, oc=(board[i]&32);
  unsigned char piece=board[i];
  if(piece == '0') oc=3;
  if(oc==0) {
    t=worth[worth_ind(piece)];
    ratingw[0]+=fieldrating[i]*10+t*100;

   if(turn[0] == 'b' && (boardw[0][i]<boardw[1][i] || (boardheavy[0][i]<boardheavy[1][i] && boardw[1][i]>2)))
   {
    ratingb[0]+=t*75;
   }
  }
  else if(oc==32) {
    t=worth[worth_ind(piece)];
    ratingb[0]+=fieldrating[i]*10+t*100;

   if(turn[0] == 'w' && (boardw[0][i]>boardw[1][i] || (boardheavy[0][i]>boardheavy[1][i] && boardw[0][i]>2)))
   {
    ratingw[0]+=t*75;
   }
  }

  ratingw[0]+=boardw[0][i]*15*fieldrating[i];
  ratingb[0]+=boardw[1][i]*15*fieldrating[i];
 }
 if(wmoved[0] == '2'||(wmoved[0] == '0' && (wmoved[1] == '0' || wmoved[2] == '0')))
  ratingw[0]+=300;
 if(bmoved[0] == '2'||(bmoved[0] == '0' && (bmoved[1] == '0' || bmoved[2] == '0')))
  ratingb[0]+=300;

 if(wmoved[0] == '2') ratingw[0]+=800;
 if(bmoved[0] == '2') ratingb[0]+=800;

 for(char j=0;j<8;j++)
 {
  char v=j, plw=0, plb=0;
  for(char i=0;i<8;i++)
  {
   if(board[v] == 'P')
   {
    plw++;
    if (i==1&&(j==3||j==4)) ratingw[0]-=300;
   }
   else if(board[v] == 'p')
   {
    plb++;
    if (i==6&&(j==3||j==4)) ratingb[0]-=300;
   }
   v+=8;
  }
  if(plw==0) ratingw[0]+=250;
  else if(plw>1) ratingw[0]-=500*(plw-1);
  if(plb==0) ratingb[0]+=250;
  else if(plb>1) ratingb[0]-=500*(plb-1);

  if(debug)
  {
   char line[100];
   sprintf(line,"line %d: %d - %d\n",j,plw,plb);
   write(fn,line,strlen(line));
  }
 }

 if(debug)
  close(fn);
}
//---------------------------------------------------------------------------

void getbestmove(char* move, long* rw, long* rb, char* board, char* turn, char* lastfrom, char* lastto, char* wmoved, char* bmoved, char depth, char ply, long fn, long *mp)
{
 long ratingw=0, ratingb=0;
 unsigned char allvalids[200], valids[30];
 long avc=0;

 for(long i=0;i<64;i++)
 {
  if(((board[i]&32) == 0 && turn[0] == 'w') || ((board[i]&32) == 32 && turn[0] == 'b')) {
   char vc = getvalidmoves(valids, (i&7), (i>>3), board, lastfrom, lastto, wmoved, bmoved);
   for(long j=0;j<vc;j++)
   {
    allvalids[avc]=i;  avc++;
    allvalids[avc]=valids[j]; avc++;
   }
  }
 }

 if(avc==0)
 {
  char kx=0, ky=0;

  if(turn[0] == 'w')
  {
   for(char i=0;i<64;i++)
   if(board[i] == 'K')
    { ky=(i>>3); kx=i&7; i=65; }
   rw[0]=0;
   rb[0]=depth*100000;
   if(!ischeck(kx,ky,32,board)) rb[0]=0;
  }
  else
  {
   for(char i=0;i<64;i++)
   if(board[i] == 'k')
    { ky=(i>>3); kx=i&7; i=65; }
   rb[0]=0;
   rw[0]=depth*100000;
   if(!ischeck(kx,ky,0,board)) rw[0]=0;   
  }
  move[0]=move[1]=7;
  move[2]=' ';
  return;
 }

 #ifdef DEBUG
 char line[100]={0};
 #endif
 long bestdif=-1000000;
 long bestmove=0;
 char nextturn=(turn[0] == 'w'?'b':'w');
 char saveboard[64];
 char savewmoved[3], savebmoved[3];
 char slastfrom[2], slastto[2];
  #ifdef DEBUG
  line[0]=0;
  sprintf(line+strlen(line)," starting ply: %d %d - moves: %d\n",ply,depth,avc/2);
  write(fn,line,strlen(line));
  #endif
 for(long i=0;i<avc;i+=2)
 {
  memcpy(saveboard, board, 64);
  memcpy(savewmoved, wmoved, 3);
  memcpy(savebmoved, bmoved, 3);
  char actpiece=board[allvalids[i]];
  if(tolower(actpiece) == 'p')
  {
   if(board[allvalids[i+1]] == '0' && (allvalids[i+1]&7) != (allvalids[i]&7))
   {
    unsigned captppos=(allvalids[i+1]+((board[allvalids[i]]&32) == 0 ? -8 : 8));
    board[captppos] = '0';
   }
  }
  else if(actpiece == 'K')
  {
   if(wmoved[0] == '0') wmoved[0]='1';
   if(allvalids[i] == 4)
   {
    if(allvalids[i+1] == 6)
    {
     board[7]='0';
     board[5]='R';
     wmoved[0]='2';
    }
    else if(allvalids[i+1] == 2)
    {
     board[0]='0';
     board[3]='R';
     wmoved[0]='2';
    }
   }
  }
  else if(actpiece == 'k')
  {
   if(bmoved[0] == '0') bmoved[0]='1';
   else if(allvalids[i] == 60)
   {
    if(allvalids[i+1] == 62)
    {
     board[63]='0';
     board[61]='r';
     bmoved[0]='2';
    }
    else if(allvalids[i+1] == 58)
    {
     board[56]='0';
     board[59]='r';
     bmoved[0]='2';
    }
   }
  }
  board[allvalids[i+1]]=board[allvalids[i]];
  board[allvalids[i]]='0';
  if(actpiece == 'P' && (allvalids[i+1]>>3) == 7) { board[allvalids[i+1]]='Q'; }
  else if(actpiece == 'p' && (allvalids[i+1]>>3) == 0) { board[allvalids[i+1]]='q'; }

  if(actpiece == 'R')
  {
   if(allvalids[i] == 0) wmoved[1] = '1';
   if(allvalids[i] == 7) wmoved[2] = '1';
  }
  else if(actpiece == 'r')
  {
   if(allvalids[i] == 56) bmoved[1] = '1';
   if(allvalids[i] == 63) bmoved[2] = '1';
  }

  #ifdef DEBUG
  line[0]=0;
  for(long j=0;j<ply-1;j++)
   sprintf(line+strlen(line),"   ");
  sprintf(line+strlen(line),"%s%c%c-%c%c\n",(ply==1?"--":""),((int)allvalids[i]&7)+65,(allvalids[i]>>3)+49,((int)allvalids[i+1]&7)+65,(allvalids[i+1]>>3)+49);
  write(fn,line,strlen(line));
  #endif
  mp[0]++;
  slastfrom[0]=(allvalids[i]&7); slastfrom[1]=(allvalids[i]>>3);
  slastto[0]=(allvalids[i+1]&7); slastto[1]=(allvalids[i+1]>>3);
  if(depth>1&&avc>2)
   getbestmove(move, &ratingw, &ratingb, board, &nextturn, slastfrom, slastto, wmoved, bmoved, depth-1, ply+1, fn, mp);
  else
   rateposition(&ratingw, &ratingb, board, &nextturn, wmoved, bmoved, false);
  #ifdef DEBUG
  line[0]=0;
  sprintf(line+strlen(line)," %d : %d",ratingw,ratingb);
  #endif
  long newdif;
  if(turn[0] == 'w')
   newdif=ratingw-ratingb;
  else
   newdif=ratingb-ratingw;
  if(newdif>bestdif||(newdif==bestdif&&!random(4)))
  {
   #ifdef DEBUG
   sprintf(line+strlen(line)," * %d %d",bestdif,newdif);
   #endif
   bestdif=newdif;
   bestmove=i;
   rw[0]=ratingw;
   rb[0]=ratingb;
  }
  #ifdef DEBUG
  sprintf(line+strlen(line),"\n");
  write(fn,line,strlen(line));
  #endif
  memcpy(bmoved, savebmoved, 3);
  memcpy(wmoved, savewmoved, 3);
  memcpy(board, saveboard, 64);
 }
 memcpy(move,&allvalids[bestmove],2);
 if(board[move[0]] == 'P' && (move[1]>>3) == 7) { move[2]='Q'; }
 else if(board[move[0]] == 'p' && (move[1]>>3) == 0) { move[2]='q'; }
 else move[2] = ' ';
}
//---------------------------------------------------------------------------

