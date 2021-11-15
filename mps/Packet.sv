`ifndef INC_PACKET_SV
`define INC_PACKET_SV
class particle_hit;//粒子类
	int size;//撞击cluster大小
	int cluster_type;//撞击cluster形状
	int x,y;//粒子位置
	bit matrix [][];//cluster矩阵
	function new(int size_n,int cluster_type_n,int x_n,int y_n);
		size=size_n;
		cluster_type=cluster_type_n;
		x=x_n;
		y=y_n;
	endfunction
	function void custom();//矩阵初始化
		matrix=new[size];
		foreach(matrix[i])
			matrix[i]=new[size];
		foreach(matrix[i,j])
			matrix[i][j]=0;//初始化为全零
		case(cluster_type)
			0: begin//方形
				foreach(matrix[i,j])
				matrix[i][j]=1;
				end
			1: begin//下三角形
				foreach(matrix[i,j])
				matrix[i][j]=(j<=i?1:0);
				end
			2: begin//上三角形
				foreach(matrix[i,j])
				matrix[i][j]=((j<=size-i-1)?1:0);
				end
			3: begin//左三角形
				foreach(matrix[i,j])
				matrix[i][j]=(j>=i?1:0);
				end
			4: begin//右三角形
				foreach(matrix[i,j])
				matrix[i][j]=((j>=size-i+1)?1:0);
				end
		endcase
	endfunction
	
endclass
class ranpacket;//随机数
	rand bit  [31:0]x;
	rand bit [31:0]y;
	rand bit [7:0] size;
	rand bit [3:0] cluster_type;
	int xmax;
	int xmin;
	int ymax;
	int ymin;
	function new(int xmax_n,int ymax_n);
		xmax=xmax_n;
		ymax=ymax_n;
	endfunction
	constraint c_size {size>0;size<5;}
	constraint c_x {x>=0;x<=xmax-size;}
	constraint c_y {y>=0;y<=ymax-size;}
	constraint c_cluster_type {cluster_type>=0;cluster_type<=2;}
	

endclass

class image;//图像
	int m,n;//图像大小
	int density;//粒子密度
	int frame;//帧数
	bit img[][];
	int seed;
	function new(int m_n,int n_n,int density_n,int frame_n,int seed_n);
		m=m_n;
		n=n_n;
		density=density_n;
		frame=frame_n;
		seed=seed_n;
		img=new[m];
		foreach(img[i])
			img[i]=new[n];
		foreach(img[i,j])
			img[i][j]=0;
	endfunction
	function void clear();
		foreach(img[i,j])
			img[i][j]=0;
	endfunction
	
	function void custom();
		ranpacket ranpacket_h[];
		particle_hit particle_hit_m[];//粒子个数
		particle_hit_m=new[density];
		ranpacket_h=new[density];
		foreach(ranpacket_h[i])
			begin
			ranpacket_h[i]=new(n,m);
			ranpacket_h[i].srandom(this.seed-i);
			//$display("%d",this.seed);
			if(ranpacket_h[i].randomize()) ;
			end
		foreach(particle_hit_m[i])
			begin
			particle_hit_m[i]=new(ranpacket_h[i].size,ranpacket_h[i].cluster_type,ranpacket_h[i].x,ranpacket_h[i].y);
			particle_hit_m[i].custom();
			copy(particle_hit_m[i]);
			end
	endfunction
	
	function void copy(particle_hit particle_hit_x);
	foreach(particle_hit_x.matrix[i,j])
		img[i+particle_hit_x.x][j+particle_hit_x.y]=img[i+particle_hit_x.x][j+particle_hit_x.y]|particle_hit_x.matrix[i][j];
	
	endfunction
	
	function  void display();
	foreach(img[i])
		begin
			foreach(img[i,j])
				$write("%d",img[i][j]);
			$write("\n");
		end		
	endfunction

endclass

class Packet;
  image image_h;
  rand bit [7:0] cmd;
  string   name;
  extern function new(string name = "Packet",int seed,int den);
  extern function void compare(Packet pkt2cmp);
  extern function void display();
  extern virtual task readbmp();
  extern virtual task makebmp();
endclass

function Packet::new(string name = "Packet",int seed,int den);
  this.name = name;
  image_h=new(64,64,den,1,seed);
  image_h.custom();
endfunction

function void Packet::compare(Packet pkt2cmp);
	real rate;
	real wate;
	real num;
	real num2;
	wate=0;
	rate=0;
	num=0;
	num2=0;
  foreach(image_h.img[i,j])
	begin
		if(pkt2cmp.image_h.img[i][j]==image_h.img[i][j]) 
			begin
				if(pkt2cmp.image_h.img[i][j]==1'b1) rate=rate+1;
			end
		else
			begin
				wate=wate+1;
			end
		
		num2=num2+((pkt2cmp.image_h.img[i][j]==1'b1)?1:0);
		
		num=num+((image_h.img[i][j]==1'b1)?1:0);
	end
	$display("image%s match right rate=%f ,wrong rate=%f   num=%f  num2=%f",name,rate/num,wate/num,num,num2);
endfunction

function  void Packet::display();//帧显示
	$display("%s:%b",name,cmd);
	foreach(image_h.img[i])
		begin
			foreach(image_h.img[i][j])
				$write("%d",image_h.img[i][j]);
			$write("\n");
		end
		
endfunction
task Packet::readbmp();//读入位图
	bit [7:0] data;
	int fpointer;
	int q;
	int k;
	fpointer=$fopen("bmpinput.bmp","rb");
	repeat(62) $fgetc(fpointer);
	foreach(image_h.img[i])
		begin
			for(q=0;q<8;q=q+1)
				begin
					data=$fgetc(fpointer);
					for(k=0;k<8;k=k+1)
						begin
							image_h.img[i][q*8+k]=~data[k];
						end
				end
			
		end
	$fclose(fpointer);
	
endtask
task Packet::makebmp();//画位图
	bit [7:0] data;
	int fpointer;
	int q;
	int k;
	int pos;
	fpointer=$fopen("bmpoutput.bmp","rb+");
	$fseek(fpointer,62,0);
	foreach(image_h.img[i])
		begin
			for(q=0;q<8;q=q+1)
				begin
					for(k=0;k<8;k=k+1)
						begin
							data[k]=~image_h.img[i][q*8+k];	
						end
					$fwrite(fpointer,"%c",data);
				end
			
		end
	$fclose(fpointer);
	$display("makebmp successfull");
endtask

covergroup covport(ref Packet pak);//指令覆盖率
	coverpoint pak.cmd;
endgroup

`endif
