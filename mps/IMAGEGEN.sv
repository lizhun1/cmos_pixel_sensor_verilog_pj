`define width 3
`define length 3
typedef class Packet;
typedef mailbox #(Packet) pkt_mbox;

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
	function custom();//矩阵初始化
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
	function new(int m_n,int n_n,int density_n,int frame_n);
		m=m_n;
		n=n_n;
		density=density_n;
		frame=frame_n;
		img=new[m];
		foreach(img[i])
			img[i]=new[n];
		foreach(img[i,j])
			img[i][j]=0;
	endfunction
	
	function custom();
		ranpacket ranpacket_h[];
		particle_hit particle_hit_m[];//粒子个数
		particle_hit_m=new[density];
		ranpacket_h=new[density];
		foreach(ranpacket_h[i])
			begin
			ranpacket_h[i]=new(n,m);
			ranpacket_h[i].randomize();
			end
		foreach(particle_hit_m[i])
			begin
			particle_hit_m[i]=new(ranpacket_h[i].size,ranpacket_h[i].cluster_type,ranpacket_h[i].x,ranpacket_h[i].y);
			particle_hit_m[i].custom();
			copy(img,particle_hit_m[i]);
			end
	endfunction
endclass
function automatic copy(ref bit img[][],ref particle_hit particle_hit_x);
	foreach(particle_hit_x.matrix[i,j])
		img[i+particle_hit_x.x][j+particle_hit_x.y]=img[i+particle_hit_x.x][j+particle_hit_x.y]|particle_hit_x.matrix[i][j];
	
endfunction
class Packet;
  rand bit[3:0] sa, da;         // random port selection
  rand logic[7:0] payload[$];	// random payload array
       string   name;		// unique identifier

  constraint Limit {
    sa inside {[0:15]};
    da inside {[0:15]};
    payload.size() inside {[2:4]};
  }

  extern function new(string name = "Packet");
  extern function bit compare(Packet pkt2cmp, ref string message);
  extern function void display(string prefix = "NOTE");
endclass

function Packet::new(string name);
  this.name = name;
endfunction

function bit Packet::compare(Packet pkt2cmp, ref string message);
  if (payload.size() != pkt2cmp.payload.size()) begin
    message = "Payload Size Mismatch:\n";
    message = { message, $psprintf("payload.size() = %0d, pkt2cmp.payload.size() = %0d\n", payload.size(), pkt2cmp.payload.size()) };
    return(0);
  end
    if (payload == pkt2cmp.payload) ;
    else begin
      message = "Payload Content Mismatch:\n";
      message = { message, $psprintf("Packet Sent:  %p\nPkt Received: %p", payload, pkt2cmp.payload) };
      return(0);
    end
  message = "Successfully Compared";
  return(1);
endfunction

function void Packet::display(string prefix);
  $display("[%s]%t %s sa = %0d, da = %0d", prefix, $realtime, name, sa, da);
  foreach(payload[i])
    $display("[%s]%t %s payload[%0d] = %0d", prefix, $realtime, name, i, payload[i]);
endfunction

