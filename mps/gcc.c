#include <stdio.h> 
#include <stdlib.h>
typedef  struct  tagBITMAPFILEHEADER
{ 
unsigned short int  bfType;       //位图文件的类型，必须为BM 
unsigned long       bfSize;       //文件大小，以字节为单位
unsigned short int  bfReserverd1; //位图文件保留字，必须为0 
unsigned short int  bfReserverd2; //位图文件保留字，必须为0 
unsigned long       bfbfOffBits;  //位图文件头到数据的偏移量，以字节为单位
}BITMAPFILEHEADER; 
typedef  struct  tagBITMAPINFOHEADER 
{ 
long biSize;                        //该结构大小，字节为单位
long  biWidth;                     //图形宽度以象素为单位
long  biHeight;                     //图形高度以象素为单位
short int  biPlanes;               //目标设备的级别，必须为1 
short int  biBitcount;             //颜色深度，每个象素所需要的位数
short int  biCompression;        //位图的压缩类型
long  biSizeImage;              //位图的大小，以字节为单位
long  biXPelsPermeter;       //位图水平分辨率，每米像素数
long  biYPelsPermeter;       //位图垂直分辨率，每米像素数
long  biClrUsed;            //位图实际使用的颜色表中的颜色数
long  biClrImportant;       //位图显示过程中重要的颜色数
}BITMAPINFOHEADER; 
typedef  struct 
{ 
BITMAPFILEHEADER  file; //文件信息区
BITMAPINFOHEADER  info; //图象信息区
}bmp;

bmp  readbmpfile(void); //函数声明
int main(void)

{ 
  bmp m;          //定义一个结构变量
  m=readbmpfile(); //读取一个位图
  getchar();
  return 0;

}

 

  bmp  readbmpfile(void) 
{ bmp  m;        //定义一个位图结构
  FILE *fp; 
 if((fp=fopen( "d:\\1.bmp", "r"))==NULL) 
 { printf( "can't open the bmp imgae.\n "); 
   exit(0); 
 }

else 
{ 
fread(&m.file.bfType,sizeof(char),1,fp); 
printf("类型为%c",m.file.bfType); 
fread(&m.file.bfType,sizeof(char),1,fp); 
printf("%c\n",m.file.bfType);        
fread(&m.file.bfSize,sizeof(long),1,fp); 
printf("文件长度为%d\n",m.file.bfSize);  
fread(&m.file.bfReserverd1,sizeof(short int),1,fp); 
printf("保留字1为%d\n",m.file.bfReserverd1); 
fread(&m.file.bfReserverd2,sizeof(short int),1,fp); 
printf("保留字2为%d\n",m.file.bfReserverd2); 
fread(&m.file.bfbfOffBits,sizeof(long),1,fp); 
printf("偏移量为%d\n",m.file.bfbfOffBits);
fread(&m.info.biSize,sizeof(long),1,fp); 
printf("此结构大小为%d\n",m.info.biSize); 
fread(&m.info.biWidth,sizeof(long),1,fp); 
printf("位图的宽度为%d\n",m.info.biWidth);
fread(&m.info.biHeight,sizeof(long),1,fp); 
printf("位图的高度为%d\n",m.info.biHeight);
fread(&m.info.biPlanes,sizeof(short),1,fp); 
printf("目标设备位图数%d\n",m.info.biPlanes);
fread(&m.info.biBitcount,sizeof(short),1,fp); 
printf("颜色深度为%d\n",m.info.biBitcount);
fread(&m.info.biCompression,sizeof(long),1,fp); 
printf("位图压缩类型%d\n",m.info.biCompression); 
fread(&m.info.biSizeImage,sizeof(long),1,fp); 
printf("位图大小%d\n",m.info.biSizeImage); 
fread(&m.info.biXPelsPermeter,sizeof(long),1,fp); 
printf("位图水平分辨率为%d\n",m.info.biXPelsPermeter); 
fread(&m.info.biYPelsPermeter,sizeof(long),1,fp); 
printf("位图垂直分辨率为%d\n",m.info.biYPelsPermeter); 
fread(&m.info.biClrUsed,sizeof(long),1,fp); 
printf("位图实际使用颜色数%d\n",m.info.biClrUsed);
fread(&m.info.biClrImportant,sizeof(long),1,fp); 
printf("位图显示中比较重要颜色数%d\n",m.info.biClrImportant); 
} 
return m; 
}