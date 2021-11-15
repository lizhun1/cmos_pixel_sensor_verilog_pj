typedef struct { 
bit [15:0]  bfType;       //位图文件的类型，必须为BM 
bit [31:0]  bfSize;       //文件大小，以字节为单位
bit [31:0]  bfReserverd1; //位图文件保留字，必须为0 
bit [31:0]  bfbfOffBits;  //位图文件头到数据的偏移量，以字节为单位
} BITMAPFILEHEADER;

typedef  struct{ 
bit [31:0]  biSize;                        //该结构大小，字节为单位
bit [31:0]   biWidth;                     //图形宽度以象素为单位
bit [31:0]   biHeight;                     //图形高度以象素为单位
bit [15:0]   biPlanes;               //目标设备的级别，必须为1 
bit [15:0]  biBitcount;             //颜色深度，每个象素所需要的位数
bit [15:0]  biCompression;        //位图的压缩类型
bit [31:0]  biSizeImage;              //位图的大小，以字节为单位
bit [31:0]  biXPelsPermeter;       //位图水平分辨率，每米像素数
bit [31:0]  biYPelsPermeter;       //位图垂直分辨率，每米像素数
bit [31:0]  biClrUsed;            //位图实际使用的颜色表中的颜色数
bit [31:0]  biClrImportant;       //位图显示过程中重要的颜色数
}BITMAPINFOHEADER; 
typedef struct { 
bit [7:0]   rgbBlue; 
bit [7:0]   rgbGreen; 
bit [7:0]   rgbRed; 
bit [7:0]   rgbReserved; 
} RGBQUAD;
typedef  struct{ 
BITMAPFILEHEADER  file; //文件信息区
BITMAPINFOHEADER  info; //图象信息区
}bmp;
