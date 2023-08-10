import 'package:flutter/material.dart';
import 'dart:ui';
import 'chats.dart';

class ScrollableUserList extends StatefulWidget {
  const ScrollableUserList({super.key});

  @override
  State<ScrollableUserList> createState() => _ScrollableUserListState();
}

class _ScrollableUserListState extends State<ScrollableUserList>
  with TickerProviderStateMixin {

  final List<User> userList = [
    User(id: "1", name: "John"),
    User(id: "2", name: "Alice"),
    User(id: "3", name: "alex"),
    User(id: "4", name: "Bob"),
    User(id: "5", name: "sam"),
    User(id: "6", name: "dominic"),
    User(id: "7", name: "cliff"),
    User(id: "8", name: "lockne"),
    User(id: "9", name: "harry"),
    User(id: "10", name: "kane"),
    User(id: "11", name: "sara"),
  ];

  final List<IconData> _icons = [Icons.person_add_alt, Icons.group_add_outlined, Icons.add_circle_outline];
  late TabController tabController;
  late AnimationController _animationController;

  int usersNum = 0;
  int grpNum = 0;
  int activeTab = 0;

  @override
  void initState(){
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration:const Duration(milliseconds: 300),
    );

    tabController = TabController(length: 3, vsync: this, initialIndex: activeTab);
    tabController.addListener(() {
      if(tabController.index != activeTab) {
        setState(() {
          activeTab = tabController.index;
          _animationController.reset();
          _animationController.forward();
        });
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

    Size size = MediaQuery.of(context).size;

    final List<Widget> tabs = <Widget>[
      const Messages(),
      GroupsTab(count: grpNum), 
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
                        

                        IconButton(
                          padding: const EdgeInsets.only(right: 10),
                          onPressed: () => {},
                          icon:const Icon(Icons.search, size: 30,),
                          color: const Color.fromARGB(225, 250, 79, 79),
                          splashRadius: 1,
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: IconButton(
                            key: ValueKey<int>(tabController.index),
                            icon: Icon(_icons[tabController.index],
                              color: const Color.fromARGB(225, 250, 79, 79),
                            ),
                            onPressed: () {
                              setState(() {
                                grpNum+=1;
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
                  delegate: BoomBam(60.0, tabController),
                ),
              ];
            },
            body:Padding(
              padding:const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child :Container(
                padding:const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(200, 255, 186, 186),
                  borderRadius:  BorderRadius.all(Radius.circular(30))
                ),
                child : TabBarView(
                  viewportFraction: 10.0,
                  controller: tabController,
                  physics:const PageScrollPhysics(),
                    children: tabs.map(
                      (content) {
                        return  CustomScrollView(
                          scrollBehavior:const MaterialScrollBehavior(),
                          shrinkWrap: true,
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

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});
}

class BoomBam extends SliverPersistentHeaderDelegate {
  final double size;
  final TabController tabController;

  BoomBam(this.size, this.tabController);

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
          Tab(child: Icon(Icons.circle_outlined, size: 25)),
        ],
      ),
    );
  }

  @override
  double get maxExtent => size;

  @override
  double get minExtent => size;

  @override
  bool shouldRebuild(BoomBam oldDelegate) {
    return oldDelegate.size != size;
  }
}

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

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
                builder: (context) => MyMessagesPage(index: index,name: "Mr. k",),
              ),
            );
            },
          );
        },
        childCount: 10
      ),
    );
  }
}

class GroupsTab extends StatelessWidget {
  const GroupsTab({Key? key, required this.count}) : super(key: key);

  final int count;

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
                builder: (context) => MyMessagesPage(index: index,name: "Mr. k",),
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
                builder: (context) => MyMessagesPage(index: index,name: "Mr. k",),
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

