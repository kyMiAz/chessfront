<template>
<body onselectstart="return false;">
 <div>
   <h2 id="title"></h2>
   <canvas id="canvas"  width="" height="">
     浏览器版本太低，请升级！
   </canvas>
   <canvas id="canvas1" width="" height=""></canvas>
 </div>
</body>
</template>

<script>
const axios=require('axios').default;
export default {

mounted(){
    this.draw()
},
methods:{

  draw(){
    var x=null;// eslint-disable-line no-unused-vars
    //是否需要自己下，让机器学 默认否
    let memory=false;// eslint-disable-line no-unused-vars
    //判断当前是哪边出手1表示"汉方"0表示"楚方"
    var whose = 1;
    //存储字符串
   var nextboard="";// eslint-disable-line no-unused-vars
   var robot=[];// eslint-disable-line no-unused-vars
   //用数组形式两个两个存储
   var next=[];// eslint-disable-line no-unused-vars
    //参数：x坐标，y坐标，哪边下子，判断是红棋还是黑棋，判断是什么棋
    var desc_click = [0,0,0,-1,0];
     //建一个数组来存放我们点击的那个棋子的所有参数
    var chess = [
      //['名称(txt)','横坐标x','纵坐标y','哪边下子','判断是红棋还是黑棋','判断是什么棋']
      //chess.length = 32，一共32颗棋子
        ['車',8,9,1,1,1],['馬',7,9,1,1,2],['相',6,9,1,1,3],['仕',5,9,1,1,4],
        ['帅',4,9,1,1,5],['仕',3,9,1,1,4],['相',2,9,1,1,3],['馬',1,9,1,1,2],
        ['車',0,9,1,1,1],['炮',7,7,1,1,6],['炮',1,7,1,1,6],
        ['兵',8,6,1,1,7],['兵',6,6,1,1,7],['兵',4,6,1,1,7],['兵',2,6,1,1,7],['兵',0,6,1,1,7],
        ['車',0,0,1,0,1],['馬',1,0,1,0,2],['象',2,0,1,0,3],['士',3,0,1,0,4],
        ['将',4,0,1,0,5],['士',5,0,1,0,4],['象',6,0,1,0,3],['馬',7,0,1,0,2],
        ['車',8,0,1,0,1],['炮',1,2,1,0,6],['炮',7,2,1,0,6],
        ['卒',0,3,1,0,7],['卒',2,3,1,0,7],['卒',4,3,1,0,7],['卒',6,3,1,0,7],['卒',8,3,1,0,7]
    ];
    window.onload = function (){
      /** @type {HTMLCanvasElement} */ 
        var canvas = document.getElementById("canvas");
        var canvas1 = document.getElementById("canvas1");
        canvas.width = 500;
        canvas.height = 650;
        canvas1.width = 500;
        canvas1.height = 650;
        var context = canvas.getContext("2d");
        var context1 = canvas1.getContext("2d");
        draw_ChessBoard(context1);//画棋盘
        draw_Chess_All(context);//画棋子 
        update_title();//更换当前的出手的人
        canvas.onclick = function(e){
          //三个参数 第一个是当前的context，第二个是点击的棋子到画板左边的距离，第三个是当前点击的棋子到画板上边的距离
          get_Chess(context,e.clientX - canvas.offsetLeft,e.clientY - canvas.offsetTop);
        }
    }
    function draw_ChessBoard(context){
      /** @type {HTMLCanvasElement} */ 
        //定义线宽
        context.lineWidth = 2;   
        //开始画线
        var gradient=context.createLinearGradient(0,0,500,0);
        gradient.addColorStop("0","magenta");
        gradient.addColorStop("0.5","blue");
        gradient.addColorStop("1.0","red");  
        context.strokeStyle=gradient  
        //画横线
        context.beginPath();
        for (var i = 1; i <= 10; i++) {  
            context.moveTo(50,50*i+50);
            context.lineTo(450,50*i+50);   
        }
        context.closePath(); 
        context.stroke(); 
        gradient=context.createLinearGradient(0,0,500,0);
        gradient.addColorStop("0.3","red");
        gradient.addColorStop("0.3","blue");
        gradient.addColorStop("1.0","magenta");  
        context.strokeStyle=gradient
        //画竖线
        context.beginPath()
        for ( i = 1; i <= 9; i++) {
            if(i==1||i==9){
                context.moveTo(50*i,100);
                context.lineTo(50*i,550);
            }else{
                context.moveTo(50*i,100);
                context.lineTo(50*i,300);
                context.moveTo(50*i,350);
                context.lineTo(50*i,550);
            }
        }
        context.closePath()
        context.stroke();

        //画中心的斜线
        context.beginPath();
        context.moveTo(200,100);
        context.lineTo(300,200);
        context.moveTo(300,100);
        context.lineTo(200,200);

        context.moveTo(200,450);
        context.lineTo(300,550);
        context.moveTo(300,450);
        context.lineTo(200,550);
        context.stroke();

        context.beginPath();

        for (i = 0; i < 2; i++) {
            for (var j = 0; j < 2; j++) {
                //绘制炮的位置的四个标记
                //绘制左上角的
                context.moveTo(85 + 300*i,195 + 250*j);
                context.lineTo(95 + 300*i,195 + 250*j);
                context.lineTo(95 + 300*i,185 + 250*j);
                //绘制右上角的
                context.moveTo(105 + 300*i,185 + 250*j);
                context.lineTo(105 + 300*i,195 + 250*j);
                context.lineTo(115 + 300*i,195 + 250*j);
                //绘制左下角
                context.moveTo(85 + 300*i,205 + 250*j);
                context.lineTo(95 + 300*i,205 + 250*j);
                context.lineTo(95 + 300*i,215 + 250*j);
                //绘制右下角
                context.moveTo(105 + 300*i,215 + 250*j);
                context.lineTo(105 + 300*i,205 + 250*j);
                context.lineTo(115 + 300*i,205 + 250*j);
            }
        }
         context.stroke();
        //临时存储一下
        context.save();

        //画楚河汉界
        context.beginPath();
        context.lineWidth = 3;
        context.strokeRect(46,96,408,458);
        context.fillStyle = 'rgba(255,255,255,0.1)';
        context.fillRect(51,301,398,48);
        context.restore();

        context.save();
        context.font = "bold 40px SimSun";
        context.translate(100,345);
        context.rotate(-90*Math.PI/180);
        context.fillStyle="#058"
        context.fillText("楚",0,40);
        context.restore();

        context.save();
        context.font = "bold 40px SimSun";
        context.translate(150,345);
        context.rotate(-90*Math.PI/180);
        context.fillStyle="#058"
        context.fillText("河",0,40);
        context.restore();

        context.save();
        context.font = "bold 40px SimSun";
        context.translate(400,305);
        context.rotate(90*Math.PI/180);
        context.strokeText("汉",0,40);
        context.restore();

        context.save();
        context.font = "bold 40px SimSun";
        context.translate(350,305);
        context.rotate(90*Math.PI/180);
        context.strokeText("界",0,40);
        context.restore();
    }
    //画所有棋子
    function draw_Chess_All(context){
        for (var i = 0;i < chess.length; i++) {
            if (chess[i][1]!=9||chess[i][2]!=9) {
                draw_Chess_One(context,(chess[i][1]+1)*50,(chess[i][2]+2)*50,chess[i][0],chess[i][4]);
            }
        }
    }
    function draw_Chess_One(context,x,y,txt,p){
        //p值是判断是黑棋还是红棋
        var color = p>0?"#ff0000":"#000000";
        context.save();
        context.beginPath();
        //棋子颜色填充用的是渐变
        //为了让棋子有立体感
        var b_Color = context.createLinearGradient(x+15,y-15,x-15,y+15);
        b_Color.addColorStop(0.5,"#f3f5d5");
        b_Color.addColorStop(1,"#8c834d");
        //棋子的样式
        context.arc(x,y,22,0,2*Math.PI);
        context.fillStyle = b_Color;
        context.fill();
        //开始画棋子
        context.beginPath();
        context.arc(x,y,17,0,2*Math.PI);
        context.fillStyle = "rgb(238, 233, 218)";
        context.strokeStyle = "#c9c876";
        context.stroke();
        context.fill();

        context.beginPath();
        context.fillStyle = color;
        context.font = "900 24px  KaiTi";
        context.fillText(txt,x-12,y+8);
        context.restore();
    }
    // 绘制选中某个棋子的那个框
     function draw_checkframe(context,x,y){
         //重新画整个棋盘
         repaint(context);
         //开始画左上角
         context.beginPath();
         context.moveTo(x-23,y-10);
         context.lineTo(x-23,y-23);
         context.lineTo(x-10,y-23);
         //开始画右上角
         context.moveTo(x+10,y-23);
         context.lineTo(x+23,y-23);
         context.lineTo(x+23,y-10);
         //开始画左下角
         context.moveTo(x-23,y+10);
         context.lineTo(x-23,y+23);
         context.lineTo(x-10,y+23);
         //开始画右下角
         context.moveTo(x+23,y+10);
         context.lineTo(x+23,y+23);
         context.lineTo(x+10,y+23);
         context.stroke();
     }
    //下棋方 
     function update_title(){
        var h2 = document.getElementById("title");
        if(chess[4][1]==9&&chess[4][2]==9){
            alert("robot win！")
            h2.innerHTML="楚军胜！"
            h2.style.color ="#000000"
        }else if(chess[20][1]==9&&chess[20][2]==9){
            alert("you win！")
            h2.innerHTML="汉军胜！"
            h2.style.color ="#ff0000"
        }else{
            h2.innerHTML = whose == 1?"汉":"楚";
            h2.style.color = whose == 1?"#ff0000":"#000000";
        }
     
    }
    //每次下棋就重画
    function repaint(context){
        context.clearRect(0,0,600,650);
        draw_Chess_All(context);
    }
        //判断这颗棋子是否存在
    function is_chess(x,y){
        //定义existe判断是否这颗棋子还活着默认是死了
        var existe = false
        for(var i = 0;i<chess.length;i++){
            //如果某颗棋子的横纵坐标都有并且chess[i][3]任然等于1这个参数是true表示活着
            if(chess[i][1]==x/50-1 && chess[i][2]==y/50-2 && chess[i][3]==1){
              existe = true
              }
        }
        return existe
    }
    //这是一个判断俩个帅是否是面对面（有bug）
    function is_face_to_face(){
        //定义四个参数红色的和黑色的x,y坐标
        var r_x = 0,r_y=0,b_x=0,b_y=0,num=0;// eslint-disable-line no-unused-vars
        //定义一个状态
        var state = false;
        //
        for(var i=0;i<chess.length;i++){
            //chess[i][5]值就是从1到7分别代表不同的棋子，例如1表示军7表示兵卒
            //5表示将帅
            if(chess[i][5]==5 && chess[i][4]==1){//如果将帅活着并且1表示红棋
                //获取到这个棋子的横纵坐标
                r_x=chess[i][1];
                r_y=chess[i][2];
            }
            if(chess[i][5]==5 && chess[i][4]==0){//如果将帅活着并且0表示黑棋
                //获取到当前棋子的横纵坐标
                b_x=chess[i][1];
                b_y=chess[i][2];
            }
        }
        //如果红色和黑色的横坐标相同时
        if(r_x == b_x){
            //遍历一遍chess数组
            for( i = 0;i<chess.length;i++){
                //如果当前棋子的位置没变并且是红棋落子时
                if(chess[i][1] == r_x && chess[i][3] >0&&chess[i][2]>b_y&&chess[i][2]<r_y){num++;}
                // if(chess[i][1] == r_x && chess[i][3] >0&&chess[i][2]==r_y){num++;}
                // if(chess[i][1] == r_x && chess[i][3] >0&&chess[i][2]==b_y){num++;}
            }
            if(num == 0){state = true;}
        }
        return state;
    }
    //发送当前棋盘并接受机器发来的棋盘 重画
    function send_and_get_nextBoard(context){
        console.log("this is seng_get")
        axios.get('/suggest/'+nextboard).then((res)=>{
            console.log(res)
             if (res.data!=""){  
                 nextboard = res.data;
                 for(var i = 0;i < chess.length*2; i=i+2){
                    var j=i/2
                     chess[j][1]=parseInt(nextboard.slice(i,i+1))
                     chess[j][2]=parseInt(nextboard.slice(i+1,i+2))
                 }
                 repaint(context);
                 desc_click = [0,0,0,-1,0];
                 whose = whose ==0?1:0;
                 update_title();
                 return true;
             }else{
                memory=true;
             }
             
        })
        
    }
    //发送棋盘若可执行 便重画，不行就恢复
    function send_ChessBoard(x,move,eat,sub_x,sub_y,i,context){
        axios.get('/move/'+x+'/'+move).then((res)=>{
            console.log("this is send")
                    if (res.data!=null){
                        nextboard = res.data;
                        if(!memory)
                        {
                            robot=nextboard;
                        }
                        chess[desc_click[2]][1] = sub_x/50-1;//
                        chess[desc_click[2]][2] = sub_y/50-2;//
                        if(eat){
                            if(go(sub_x,sub_y,desc_click[4],true)){
                                chess[i][3]=0;
                                chess[i][1]=9;//棋子数赋值为99
                                chess[i][2]=9;
                                whose = whose == 0?1:0;//是不是"楚"如果是就换，如果不是就是"楚"
                                repaint(context);//调用函数重新画整个棋盘
                                if(chess[i][5] == 5) {
                                document.getElementById("canvas").onclick = null;
                                }
                                update_title();//换题
                                if(!memory){
                                send_and_get_nextBoard(context)
                                }
                                if(memory){
                                    memory_chess();
                                }
                                return;
                            }
                            return;
                        }else{
                            if(go(sub_x,sub_y,desc_click[4]))
                            { 
                                repaint(context);
                                desc_click = [0,0,0,-1,0];
                                whose = whose ==0?1:0;
                                update_title();
                                if(!memory){
                                send_and_get_nextBoard(context)
                                }
                                if(memory){
                                    memory_chess();
                                }
                                return;
                            }
                            return;
                        }
                    }else{
                       return;
                    }
                })
    }
    //数据无此下棋方式需记录
    function memory_chess(){
        console.log("this is mem")
        // for(var i = 0;i < chess.length; i++){
        //     robot.push(chess[i][1])
        //     robot.push(chess[i][2])
        // }
        let form=new FormData()
        form.set('x',robot)
        form.set('y',nextboard)
        console.log("this robot"+robot+"  "+"this next"+nextboard)
        axios.post('/memorize/',form).then((res)=>{ 
            console.log(res);
            memory=false;
        })
    }
    //获取棋子 三个参数 第一个是在canvas上画 第二个是坐标x第三个是坐标y
    function get_Chess(context,x,y){
        //定义俩个变量
        console.log("this is memory"+memory)
        var sub_x = 0,sub_y =0;
        var move="";
        var all_Chess="";
        if (x<30||y<30||x>470||y>570) {return false}
        //这里就是一个四舍五入和向下取整，以便棋子能在棋盘上按格走
        //由于传过来的x,y时是鼠标点的位置，为了能够只需要点到棋子的任何位置，就能选取
        if (x%100>80||x%100<20) {sub_x = 100*Math.round(x/100)}
        if (x%100>30&&x%100<70) {sub_x = x>100?(Math.floor(x/100)*100 + 50):50}
        if (y%100>80||y%100<20) {sub_y = 100*Math.round(y/100)}
        if (y%100>30&&y%100<70) {sub_y = y>100?(Math.floor(y/100)*100 + 50):50}
        if(sub_x > 0 && sub_y > 0){
            for (var i = 0;i < chess.length; i++) {
                if ((chess[i][1]+1)*50 == sub_x && (chess[i][2]+2)*50 == sub_y && chess[i][3] > 0) {
                    if (chess[i][4] == whose) {
                        //画选定框
                        draw_checkframe(context,sub_x,sub_y)
                        //参数：x坐标，y坐标，哪边下子，判断是红棋还是黑棋，判断是什么棋
                        //参数：x坐标,y坐标，数组里的第几个，数组的第五个参数即该哪边下，第六个参数
                        desc_click = [sub_x,sub_y,i,chess[i][4],chess[i][5]]
                        return false;
                    }
                     //这一步判断下的位置是否有对方的棋子
                    if(desc_click[3] == whose&&chess[i][4]!=whose){    
                        //吃子问题
                        for ( var j = 0;j < chess.length; j++) {
                            if(j==desc_click[2])
                            {
                                move+=""+chess[j][1]+chess[j][2];
                                move+=""+sub_x/50-1;
                                move+=""+sub_y/50-2;
                            }
                            all_Chess+=""+chess[j][1]+chess[j][2]
                        }
                            send_ChessBoard(all_Chess,move,true,sub_x,sub_y,i,context);
                    }
                    return false;
                }
            }
        }
        if(sub_x >= 50&&sub_x<=450&&sub_y>=50&&sub_y<=550&&desc_click[3] == whose){
          //移动问题
            for ( j = 0;j < chess.length; j++) {
                if(j==desc_click[2])
                {
                    move+=""+chess[j][1]+chess[j][2];
                    move+=""+sub_x/50-1;
                    move+=""+sub_y/50-2;
                }
                all_Chess+=""+chess[j][1]+chess[j][2]
            }
                send_ChessBoard(all_Chess,move,false,sub_x,sub_y,i,context);
                
        }
    }
    function go(x2,y2,txt,eat){
            //定义x1是鼠标点击的那个对象数组的第一个值 y1是第二个值
            var x1 = desc_click[0];
            var y1 = desc_click[1];
            //定义最大值和最小值
            var min_x = x1 > x2?x2:x1;
            var max_x = x1 > x2?x1:x2;
            var min_y = y1 > y2?y2:y1;
            var max_y = y1 > y2?y1:y2;
            //定义是否可以吃子
            var can_go = true;
            var num = 0;
            //判断是不是俩个将帅面对面
            if (is_face_to_face()) {
                //只能飞到对方将领那里
                can_go=true;
                // if(((chess[20][1]+1)*50==x2&&(chess[20][2]+2)*50==y2)||(chess[4][1]+1)*50==x2&&(chess[4][2]+2)*50==y2)
                // {
                //     can_go=true;
                // }else{
                //     can_go=false;
                // }
                return can_go;
            }
            //下棋
            switch (txt){
                case 1:
                    // 如果俩车不在同一条直线上
                    if(x1!=x2&&y1!=y2){
                        //不能吃子
                        can_go = false;
                        break;
                    }
                    //开始遍历
                    for(var i = 0;i < chess.length; i++){
                        //
                        if((chess[i][1]+1)*50 == x1 && (chess[i][2]+2)*50 > min_y && (chess[i][2]+2)*50 < max_y && chess[i][3] != 0){
                            can_go = false;
                        }
                        //
                        if((chess[i][2]+2)*50 == y1 && (chess[i][1]+1)*50 > min_x && (chess[i][1]+1)*50 < max_x && chess[i][3] != 0){
                            can_go = false;
                        }
                    }
                    break;
                case 2://如果是马怎么走
                    can_go = false;
                    if(x1-50==x2&&y1-100==y2&&!is_chess(x1,y1-50)){can_go = true}
                    if(x1+50==x2&&y1-100==y2&&!is_chess(x1,y1-50)){can_go = true}
                    if(x1-50==x2&&y1+100==y2&&!is_chess(x1,y1+50)){can_go = true}
                    if(x1+50==x2&&y1+100==y2&&!is_chess(x1,y1+50)){can_go = true}
                    if(x1-100==x2&&y1-50==y2&&!is_chess(x1-50,y1)){can_go = true}
                    if(x1-100==x2&&y1+50==y2&&!is_chess(x1-50,y1)){can_go = true}
                    if(x1+100==x2&&y1-50==y2&&!is_chess(x1+50,y1)){can_go = true}
                    if(x1+100==x2&&y1+50==y2&&!is_chess(x1+50,y1)){can_go = true}
                    break;
                case 3://象怎么走
                    can_go = false;
                    if(whose == 1 && (y2 < 350||x2<50||x2>450)) {break}
                    if(whose == 0 && (y2 > 300||x2<50||x2>450)) {break}
                    if(x1-100==x2&&y1-100==y2&&!is_chess(x1-50,y1-50)) {can_go=true}
                    if(x1+100==x2&&y1-100==y2&&!is_chess(x1+50,y1-50)) {can_go=true}
                    if(x1-100==x2&&y1+100==y2&&!is_chess(x1-50,y1+50)) {can_go=true}
                    if(x1+100==x2&&y1+100==y2&&!is_chess(x1+50,y1+50)) {can_go=true}
                    break;
                case 4://士怎么走
                    can_go= false;
                    if(x2<200||x2>300){break}
                    if(whose == 1&&y2<450){break}
                    if(whose == 0&&y2>200){break}
                    if(x1+50==x2&&y1+50==y2){can_go = true}
                    if(x1+50==x2&&y1-50==y2){can_go = true}
                    if(x1-50==x2&&y1+50==y2){can_go = true}
                    if(x1-50==x2&&y1-50==y2){can_go = true}
                    break;
                case 5://帅将怎么走
                    can_go = false;
                    if(x2<200||x2>300){break}
                    //红棋的帅
                    if(whose == 1&&y2<450){break}
                    //黑棋的将
                    if(whose==0&&y2>200){break}
                    //判断怎么能走
                    if(x1+50==x2&&y1==y2){can_go=true}
                    if(x1-50==x2&&y1==y2){can_go=true}
                    if(x1==x2&&y1+50==y2){can_go=true}
                    if(x1==x2&&y1-50==y2){can_go=true}
                    break;
                case 6://炮怎么走
                    //不能原地走
                    if(x1!=x2&&y1!=y2){
                        can_go = false;
                        break;
                    }
                    //如果吃子
                    if(eat){
                        for( i = 0;i < chess.length; i++){
                            if((chess[i][1]+1)*50 == x1 && (chess[i][2]+2)*50 > min_y && (chess[i][2]+2)*50 < max_y && chess[i][3] != 0){num++}
                            if((chess[i][2]+2)*50==y1&&(chess[i][1]+1)*50>min_x&&(chess[i][1]+1)*50<max_x&&chess[i][3]!=0){num++}
                        }
                        if(num!=1){can_go = false}//隔开一个才能吃
                        break;
                    }
                    //
                    for( i=0;i<chess.length;i++){
                        if((chess[i][1]+1)*50 == x1 && (chess[i][2]+2)*50 > min_y && (chess[i][2]+2)*50 < max_y && chess[i][3] != 0){can_go = false}
                        if((chess[i][2]+2)*50==y1&&(chess[i][1]+1)*50>min_x&&(chess[i][1]+1)*50<max_x&&chess[i][3]!=0){can_go = false}
                    }
                    break;
                case 7://兵1 卒0怎么走
                    if(whose==0&&y1>y2){can_go = false}//不能后退
                    if(whose==1&&y1<y2){can_go = false}
                    if(whose==0&&y1<=300&&x1!=x2){can_go = false}//过河才能左右
                    if(whose==1&&y1>=350&&x1!=x2){can_go = false}
                    if(max_x-min_x+max_y-min_y>50){can_go = false}//只能走一格不能斜着走
                    break;
            }
            return can_go;
        }
  },

}
}
</script>

<style >
body{
background: rgb(99, 27, 27);
background-image: url(../assets/1.jpg);
}
/*层级较高*/
#canvas{
z-index: 9;
position: absolute;
left: 50%;
top: 40%;
margin-left: -250px;
margin-top: -250px;
}
/*层级低但是有背景颜色*/
#canvas1{
z-index: 1;
position: absolute;
left: 50%;
top: 40%;
margin-left: -250px;
margin-top: -250px;
}
#title{
  z-index:2;
  width: 200px;
  height: 50px;
  position: absolute;
  left: 46.5%;
  top: 48%;
  margin-left: -50px;
  margin-top: -280px;
  text-align: center;
  font-size: 30px;
  font-family: 'KaiTi';
}
</style>
