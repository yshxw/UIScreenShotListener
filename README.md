# BBScreenShot

![截图1](https://github.com/huaibaobao2017/BBScreenShot/raw/master/Screenshots/IMG_0844.PNG)

示例代码：

```javascript
var demo;

function apiready() {
    
    demo = api.require('BBScreenShot');
    
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

