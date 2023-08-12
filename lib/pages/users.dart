import 'package:flutter/material.dart';
import 'chats.dart';

class ScrollableUserList extends StatefulWidget {
  const ScrollableUserList({super.key});

  @override
  State<ScrollableUserList> createState() => _ScrollableUserListState();
}

class _ScrollableUserListState extends State<ScrollableUserList>
  with TickerProviderStateMixin {

    final List<UserChatModel> userList= [
      UserChatModel(id: '1', name: 'Alexendra', imageURL: 'https//www.example.com/pic.png', messageText: 'hello', time: '1:30'),
      UserChatModel(id: '2', name: 'Alexe', imageURL: 'https//www.example.com/pic1.png', messageText: 'whats up', time: 'yesterday'),
    ];

  final List<IconData> _tabAddIcons = [Icons.person_add_alt, Icons.group_add_outlined, Icons.add_circle_outline];
  late TabController tabController;
  late AnimationController _animationController;

  bool _isExpanded = false;
  int lastTab = 0;
  int _currIndex = 0;
  int chatNum = 0;
  int activeTab = 0;

  @override
  void initState(){
    super.initState();

    tabController = TabController(length: 3, vsync: this, initialIndex: activeTab);
    _animationController = AnimationController(
      vsync: this,
      duration: tabController.animationDuration
    );

    tabController.addListener(() {
      if(tabController.index != activeTab) {
        setState(() {
          activeTab = tabController.index;
          _animationController.reset();
          _animationController.forward();
        });
      }
      if(tabController.index == 2){
        setState(() {
        _isExpanded = false;
        _currIndex = 0;
        });
      }
      if (tabController.indexIsChanging) {
        if (tabController.animation!.value == tabController.index) {
          _animationController.value = tabController.animation!.value;
    }
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = <Widget>[
      UserTab(count: userList.length, user: userList),
      const GroupsTab(count: 0),
      const Story()
    ];

    return SafeArea(
      maintainBottomViewPadding: true,
      child: DefaultTabController(
      length: 3,
      initialIndex: 1,
        child: Scaffold(
          backgroundColor:const Color.fromARGB(255, 255, 151, 151),
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  snap: true,
                  floating: true,
                  elevation: 0.0,
                  flexibleSpace:AppBar(
                      backgroundColor:const Color.fromARGB(255, 255, 151, 151),
                      title: const Text('BoomBam',
                        style: TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(225, 250, 79, 79)
                        ),
                      ),
                      actions: [
                        
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _isExpanded ? 250.0 : 0.0,
                          height: 50.0,
                          child: TextField(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(200, 255, 186, 186),
                              border:  OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(45.0)),
                              ),
                              hintText: "Search...",
                            ),
                            enabled: _isExpanded,
                          ),
                        ),
                        IconButton(
                          iconSize: 30,
                          color: const Color.fromARGB(225, 250, 79, 79),
                          icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              transitionBuilder: (child, anim) => RotationTransition(
                                    turns: child.key == const ValueKey('search')
                                        ? Tween<double>(begin: 0.75, end: 1.0).animate(anim)
                                        : Tween<double>(begin: 1.0, end: 0.75).animate(anim),
                                    child: ScaleTransition(scale: anim, child: child),
                                  ),
                              child: tabController.index == 2? null: _currIndex == 0
                                  ? const Icon(Icons.search, key:ValueKey('search'))
                                  : const Icon(
                                      Icons.close,
                                      key: ValueKey('close'),
                                    )),
                          onPressed: () {
                            setState(() {
                              _currIndex = _currIndex == 0 ? 1 : 0;
                              _isExpanded = !_isExpanded;
                            });
                          },
                        ),
                        AnimatedSwitcher(
                          duration: tabController.animationDuration,
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                              scale: _animationController, 
                              child: child
                            );
                          },
                          child: IconButton(
                            key: ValueKey<int>(tabController.index),
                            icon: Icon(_tabAddIcons[tabController.index],
                              color: const Color.fromARGB(225, 250, 79, 79),
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                              });
                              // Do something when IconButton is pressed
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () => {},
                          icon:const Icon(Icons.more_vert, size: 30,),
                          color: const Color.fromARGB(225, 250, 79, 79),
                          splashRadius: 1,
                        )
                      ],
                      elevation: 0.0,
                    )
                  ),
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: Tabs(60.0, tabController),
                ),
              ];
            },
            body:
            // TabBarView(
            //   controller: tabController,
            //   children:const [ 
            //     CustomScrollView(
            //       slivers: [
            //         // Content for Tab 1
            //         UserTab(),
            //       ],
            //     ),
            //     CustomScrollView(
            //       slivers: [
            //         // Content for Tab 2
            //         GroupsTab(count: 2),
            //       ],
            //     ),
            //     CustomScrollView(
            //       slivers: [
            //         // Content for Tab 3
            //         Story(),
            //       ],
            //     ),
            //   ],
            // )


            Padding(
              padding:const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child :Container(
                padding:const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(200, 255, 186, 186),
                  borderRadius:  BorderRadius.all(Radius.circular(30))
                ),
                child : TabBarView(
                  controller: tabController,
                  physics:const PageScrollPhysics(),
                    children: tabs.map(
                      (content) {
                        return  CustomScrollView(
                          scrollBehavior:const MaterialScrollBehavior(),
                          slivers: [
                            content
                          ]
                        );
                      },
                    ).toList(),
                  )
               )
             )
            )
          )
        )
    );
  }
}

class UserChatModel {
  final String id;
  final String name;
  final String messageText;
  final String imageURL;
  final String time;

  UserChatModel({
    required this.id, 
    required this.name,
    required this.imageURL,
    required this.messageText,
    required this.time,
  });
}

class Tabs extends SliverPersistentHeaderDelegate {
  final double size;
  final TabController tabController;

  Tabs(this.size, this.tabController);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color.fromARGB(255, 255, 151, 151),
      height: size,
      child: TabBar(
        controller: tabController,
        indicatorWeight: 3,
        indicatorColor: const Color.fromARGB(225, 250, 79, 79),
        labelColor: const Color.fromARGB(255, 250, 79, 79),
        unselectedLabelColor: Colors.white60,
        tabs:const <Widget>[

          Tab(child: Icon(Icons.chat_outlined	, size: 25)),
          Tab(child: Icon(Icons.question_answer_outlined, size: 25)),
          Tab(child: Icon(Icons.camera, size: 28)),
        ],
      ),
    );
  }

  @override
  double get maxExtent => size;

  @override
  double get minExtent => size;

  @override
  bool shouldRebuild(Tabs oldDelegate) {
    return oldDelegate.size != size;
  }
}

class UserTab extends StatelessWidget {
  const UserTab({Key? key, 
  required this.count,
  required this.user
  }) : super(key: key);

  final int count;
  final List<UserChatModel> user;

  @override
  Widget build(BuildContext context) {
    return count == 0 ? SliverToBoxAdapter( 
      child : Center(
        child: Column(
          children: [
            const SizedBox(height: 100,),
            Container(
            width: 300,
            height: 300,
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/Worried-amico.png"),
                fit: BoxFit.fill
              ),
            ),
          ),
          const SizedBox(height: 20,),
          const Text.rich(
            TextSpan(
              text: 'OOPS!!',
              children: [
                TextSpan(text: '  Sorry', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextSpan(text: " Can't see anyone ", style: TextStyle(fontSize: 20)),
                TextSpan(text: '\nMay be Try Invite Someone if they are free'),
              ]
            ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18
              ),
            ),
          ],
        )
      ) 
    )
    :
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return  ListTile(
            leading:  Hero(
              tag: user[index].id,
              child:const CircleAvatar(
                radius: 30,
                backgroundImage:NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEgzwHNJhsADqquO7m7NFcXLbZdFZ2gM73x8I82vhyhg&s"),
              ),
            ),
            title: Text(user[index].name, style: const TextStyle( fontSize: 20)),
            subtitle:  Text(user[index].messageText),
            minVerticalPadding: 20,
            trailing:  Text(user[index].time),
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyMessagesPage(id: user[index].id,name: user[index].name),
              ),
            );
            },
          );
        },
        childCount: user.length
      ),
    );
  }
}

class GroupsTab extends StatelessWidget {
  const GroupsTab({Key? key, required this.count}) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return count == 0 ? SliverToBoxAdapter( 
      child : Center(
        child: Column(
          children: [
            const SizedBox(height: 100,),
            Container(
            width: 400,
            height: 280,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/group.png"),
                fit: BoxFit.cover
              ),
            ),
          ),
          const SizedBox(height: 20,),
          const Text.rich(
            TextSpan(
              text: 'OOPS!!',
              children: [
                TextSpan(text: '  Sorry', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " Can't see anyone ", style: TextStyle(fontSize: 20)),
                TextSpan(text: '\nMay be Try joining any group'),
              ]
            ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
            ),
          ],
        )
      ) 
    )
    :
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return  ListTile(
            leading:  Hero(
              tag: 'profilepic$index',
              child:const CircleAvatar(
                radius: 30,
                backgroundImage:NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEgzwHNJhsADqquO7m7NFcXLbZdFZ2gM73x8I82vhyhg&s"),
              ),
            ),
            title:const Text(
              "Mr. H",
              style: TextStyle(
                fontSize: 20
              ),
            
            ),
            subtitle: const Text("Hey there, Isn't it cool ?"),
            minVerticalPadding: 20,
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyMessagesPage(id: '1',name: "Mr. k",),
              ),
            );
            },
          );
        },
        childCount: count
      ),
    );
  }
}
class Story extends StatelessWidget {
  const Story ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return  ListTile(
            leading:  Hero(
              tag: 'profilepic$index',
              child:const CircleAvatar(
                radius: 30,
                backgroundImage:NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEgzwHNJhsADqquO7m7NFcXLbZdFZ2gM73x8I82vhyhg&s"),
              ),
            ),
            title:const Text(
              "Mr. H",
              style: TextStyle(
                fontSize: 20
              ),
            
            ),
            subtitle: const Text("Hey there, Isn't it cool ?"),
            minVerticalPadding: 20,
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyMessagesPage(id: '1',name: "Mr. k",),
              ),
            );
            },
          );
        },
        childCount: 1
      ),
    );
  }
}

