import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Hello World")
    Component.onCompleted: {
        mojgrid.focus = true
    }

    function dobioResponseNapraviModel(response) {
        console.log("dobioResponseNapraviModel", typeof response)

        mojgrid.model=response
    }

    function request(){
        console.log("BOK")

        const xhr=new XMLHttpRequest()
        const method="GET";
        const url="http://api.themoviedb.org/4/list/1";
        xhr.open(method, url, true);
        xhr.setRequestHeader( "Authorization", 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5YjBkOGVlMGQzODdiNjdhYTY0ZjAzZDllODM5MmViMyIsInN1YiI6IjU2MjlmNDBlYzNhMzY4MWI1ZTAwMTkxMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.UxgW0dUhS62m41KjqEf35RWfpw4ghCbnSmSq4bsB32o');
        xhr.onreadystatechange=function(){
            if(xhr.readyState===XMLHttpRequest.DONE){
                var status=xhr.status;
                if(status===0 || (status>=200 && status<400)){
                    //the request has been completed successfully
//                    console.log(xhr.responseText.results)
                    dobioResponseNapraviModel(JSON.parse(xhr.responseText).results)
               }else{
                    console.log("There has been an error with the request", status, JSON.stringify(xhr.responseText))
                }
            }
        }
        xhr.send();
    }




    GridView {
        id:mojgrid
        anchors.fill: parent
        cellWidth: mojgrid.width/5
        cellHeight: 350
        model:request()
        currentIndex: modelData.id
        keyNavigationEnabled: true
        focus:true
        highlight:Rectangle{ border.color:"lightsteelblue"; border.width:200}
        highlightFollowsCurrentItem:true

//        Keys.onPressed:{
//                    if((event.key === Qt.Key_Left) || (event.key===Qt.Key_Right) || (event.key===Qt.Key_Up) || (event.key===Qt.Key_Down)){
//                        image.source="http://image.tmdb.org/t/p/w400"+modelData.poster_path
//                   }
//        }

      delegate: Rectangle{
          id: rect;
          width:(mojgrid.width/5)-15;
          height: 500;
          color:'gray';


          onFocusChanged: {
              if(focus) {
                  img.opacity=1.0
                  img.source = "http://image.tmdb.org/t/p/w400"+modelData.poster_path
              }else{
                  img.source="http://image.tmdb.org/t/p/w400" + modelData.backdrop_path
              }
          }

          Image{id:img;
              width:parent.width;
              height:parent.height-200
              source:focus?"http://image.tmdb.org/t/p/w400"+modelData.poster_path : "http://image.tmdb.org/t/p/w400" + modelData.backdrop_path
              opacity:0.5

               Rectangle{
                   id:rect2
                   width:rect.width
                   height:45
                   anchors.top:img.bottom
                   color:'black'
                 Text{
                       id:text
                       height:20
                       text:modelData.title
                       font.pointSize: 11
                       anchors.top:image.bottom
                       elide:Text.ElideNone
                       color:'white'
                   }

                 Text{
                     id:text2
                     height:15
                     text:modelData.release_date
                     font.pointSize: 10
                     anchors.left:parent.left
                     anchors.top:text.bottom
                     color:'white'

                 }

                 Text{
                     id:text3
                     height:15
                     text:modelData.vote_average
                     font.pointSize: 10
                     anchors.right:parent.right
                     anchors.top:text.bottom
                     color:'white'
                 }

                }

                MouseArea{
                id:mouse
                anchors.fill:parent

                onClicked: {
                    //parent.focus=true
                    mojgrid.currentIndex=index
                }
              }



          }

      }
    }
  }

