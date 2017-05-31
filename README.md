# UIScreenShotListener

备注：里面的 .zip文件即为模块文件，可直接上传apicloud控制台自定义模块


![截图1](https://github.com/huaibaobao2017/UIScreenShotListener/raw/master/Screenshots/IMG_0844.PNG)

示例代码：

```javascript
var demo;

function apiready() {
    
    demo = api.require('UIScreenShotListener');
    
    takeScreenShot();
}



function takeScreenShot(){
    
    demo.addEventListener({
        name:"screenshot"  //必填
    },function(ret,err){
                          
        var imagePath = ret.imagePath
        var img = $api.byId('img');
        $api.attr(img,'src',ret.imagePath);

        alert("截图临时保存路径为："+ret.imagePath);
                
    });

}
```

