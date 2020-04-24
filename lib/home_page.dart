import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hook/login_page.dart';
import 'package:rxdart/subjects.dart';
import 'common/locator.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:flutter_picker_view/flutter_picker_view.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final navManager = sl<NavigationManager>();
    final widget = useStream(navManager.currentItem).data;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: PlowzGradient(),
        title: Image.asset(
          iLogo,
          width: 200,
        ),
      ),
      body: widget,
      bottomNavigationBar: BottomNav(),
    );
  }
}

class BottomNav extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final navManager = sl<NavigationManager>();
    return BottomNavigationBar(
      backgroundColor: Colors.teal,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: navManager.currentIndex,
      onTap: navManager.navigateToIndex,
      items: navManager.items
          .map((item) => BottomNavigationBarItem(
              icon: Icon(item.icon), title: Text(item.title)))
          .toList(),
    );
  }
}

enum AnimProp { offset, opacity }

class Service {
  final String image, title;

  Service(this.image, this.title);
}

class DashboardPage extends HookWidget {
  final _items = [
    Service(iPlowzMasthead, 'Snow Removal'),
    Service(iMowzMasthead, 'Lawn Mowing'),
    Service(iLeavzMasthead, 'Yard Clean Up'),
    Service(iMulchMasthead, 'Mulch'),
    Service(iAerationMasthead, 'Aeration'),
    Service(iPlowzMasthead, 'Snow Removal'),
    Service(iMowzMasthead, 'Lawn Mowing'),
    Service(iLeavzMasthead, 'Yard Clean Up'),
    Service(iMulchMasthead, 'Mulch'),
    Service(iAerationMasthead, 'Aeration'),
    Service(iPlowzMasthead, 'Snow Removal'),
    Service(iMowzMasthead, 'Lawn Mowing'),
    Service(iLeavzMasthead, 'Yard Clean Up'),
    Service(iMulchMasthead, 'Mulch'),
    Service(iAerationMasthead, 'Aeration'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(useContext()).size.width / 2;
    return GridView.builder(
      padding: EdgeInsets.all(20),
      itemCount: _items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (_, index) {
        final _animation = MultiTween<AnimProp>()
          ..add(
              AnimProp.offset,
              Tween(
                  begin: Offset(index % 2 == 0 ? -width : width, 0),
                  end: Offset.zero),
              1.seconds)
          ..add(AnimProp.opacity, 0.0.tweenTo(1.0), 2.seconds);
        return PlayAnimation<MultiTweenValues<AnimProp>>(
            tween: _animation,
            duration: _animation.duration,
            builder: (context, _, value) {
              return Transform.translate(
                offset: value.get(AnimProp.offset),
                child: Opacity(
                  opacity: value.get(AnimProp.opacity),
                  child: GestureDetector(
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: index % 2 == 1
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40))
                              : BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  bottomLeft: Radius.circular(40)),
                          child: Image.asset(
                            _items[index].image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 20,
                          child: Text(_items[index].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                        ),
                      ],
                    ),
                    onTap: () => sl<NavigationManager>()
                        .push(DetailRoute, args: _items[index].title),
                  ),
                ),
              );
            });
      },
    );
  }
}

class Order {
  final BehaviorSubject<Address> address;
  final BehaviorSubject<Schedule> schedule;
  final BehaviorSubject<GrassLength> grassLength;

  Order()
      : address = BehaviorSubject(),
        schedule = BehaviorSubject(),
        grassLength = BehaviorSubject();
}

class Schedule extends Pickable {
  final String schedule;

  Schedule(this.schedule);
  @override
  String get pickerValue => this.schedule;

  static List<Schedule> schedules = [
    Schedule('ASAP'),
    Schedule('Today PM'),
    Schedule('Tomorrow AM'),
    Schedule('Tomorrow PM'),
  ];
}

class Address extends Pickable {
  final String address;

  Address(this.address);

  static List<Address> addresses = [
    Address('Green St Fayetteville, NY 13066'),
    Address('104 Green St Fayetteville, NY 13066'),
    Address('105 Green St Fayetteville, NY 13066'),
    Address('146 Green St Fayetteville, NY 13066'),
  ];

  @override
  String get pickerValue => this.address;
}

class GrassLength extends Pickable {
  final String grassLength;

  GrassLength(this.grassLength);

  static List<GrassLength> options = [
    GrassLength('Less than 5 in.'),
    GrassLength('Between 5-10 in.'),
    GrassLength('Over 10 in.'),
  ];

  @override
  String get pickerValue => this.grassLength;
}

class DetailPage extends HookWidget {
  final String title;

  const DetailPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = useMemoized(() => Order());
    final address = useStream(order.address);
    final schedule = useStream(order.schedule);
    final grassLength = useStream(order.grassLength);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(title),
        ),
        body: ListView(children: [
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.location_city),
            title: Text('Address'),
            subtitle: Text(address.data?.address ?? 'Tap to add address'),
            onTap: () => showSinglePicker(
                context: context,
                items: Address.addresses,
                title: 'Select address',
                onSelect: (i) => order.address.add(i)),
          ),
          ListTile(
            leading: Icon(Icons.today),
            title: Text('Schedule date'),
            subtitle: Text(schedule.data?.schedule ?? 'Tap to add schedule'),
            onTap: () => showSinglePicker(
                context: context,
                items: Schedule.schedules,
                title: 'Select schedule',
                onSelect: (i) => order.schedule.add(i)),
          ),
          ListTile(
            leading: Icon(Icons.grain),
            title: Text('Grass length'),
            subtitle: Text(
                grassLength.data?.grassLength ?? 'Tap to add grass length'),
            onTap: () => showSinglePicker(
                context: context,
                items: GrassLength.options,
                title: 'Select grass length',
                onSelect: (i) => order.grassLength.add(i)),
          ),
          NextButton(),
        ]));
  }
}

abstract class Pickable {
  String get pickerValue;
}

class NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
          child: Text('Next'),
          onPressed: () => Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('coming soon...'),
              ))),
    );
  }
}

showSinglePicker(
    {@required BuildContext context,
    @required List<Pickable> items,
    @required String title,
    @required void Function(Pickable) onSelect}) {
  PickerController pickerController =
      PickerController(count: 1, selectedItems: [0]);
  PickerViewPopup.showMode(PickerShowMode.AlertDialog,
      controller: pickerController,
      context: context,
      title: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
      cancel: Text(
        'Cancel',
        style: TextStyle(
            color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      onCancel: () => null,
      confirm: Text(
        'Confirm',
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
      onConfirm: (controller) =>
          onSelect(items[controller.selectedRowAt(section: 0)]),
      builder: (context, popup) {
        return Container(
          height: 300,
          child: popup,
        );
      },
      itemBuilder: (section, row) {
        return Text(
          items[row].pickerValue,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        );
      },
      numberofRowsAtSection: (int section) => items.length);
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Logout'),
        onPressed: () {
          final nav = sl<NavigationManager>();
          nav.navigateToIndex(0);
          nav.root(LoginRoute);
        },
      ),
    );
  }
}
