import 'package:commuting_app_mobile/utils/constants.dart';
import 'package:flutter/material.dart';

import 'common_appbar.dart';

class MainScreen extends StatelessWidget {
  Widget child;
  String? header;
  Widget? action;
  Widget? leading;
  bool hasBack;
  FloatingActionButton? floatingActionButton;
  Drawer? drawer;
  GlobalKey<ScaffoldState>? scaffoldKey;
  bool isList;
  bool loading;
  Future<void> Function()? onRefresh;

  MainScreen(
      {required this.child,
      this.header,
      this.action,
      this.leading,
      required this.hasBack,
      this.floatingActionButton,
      this.drawer,
      this.isList = true,
      this.scaffoldKey,
      this.loading = false,
      this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: backgroundColor,
        floatingActionButton: floatingActionButton,
        drawer: drawer,
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              color: backgroundColor2,
            ),
            !isList
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      header == null
                          ? SizedBox(height: 0)
                          : CommonAppbar(
                              title: header!,
                              leading: hasBack
                                  ? IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  : leading,
                              action: action,
                            ),
                      loading
                          ? LinearProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(primaryColor),
                              backgroundColor: textColorShade2,
                            )
                          : SizedBox(
                              height: 0,
                            ),
                      Expanded(child: child),
                    ],
                  )
                : onRefresh == null
                    ? _buildContent(context)
                    : RefreshIndicator(
                        onRefresh: onRefresh!,
                        child: _buildContent(context),
                      ),
          ],
        ),
      ),
    );
  }

  _buildContent(context) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        header != null
            ? SliverAppBar(
                backgroundColor: backgroundColor2,
                centerTitle: true,

                actions: action != null
                    ? [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: action!,
                        )
                      ]
                    : [],

                leading: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: hasBack
                      ? IconButton(
                          icon: Icon(Icons.arrow_back, color: primaryColor),
                          onPressed: () => Navigator.pop(context),
                        )
                      : leading == null
                          ? IconButton(
                              icon: Icon(
                                null,
                                color: primaryColor,
                              ),
                              onPressed: null)
                          : leading!,
                ),
                floating: true,
                title: Text(
                  header!,
                  style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                      color: textColor),
                ),
              )
            : SliverToBoxAdapter(
                child: SizedBox(height: 0),
              ),
        loading
            ? SliverPersistentHeader(
                pinned: true,
                delegate: PersistentHeader(
                  widget: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    backgroundColor: textColorShade2,
                  ),
                ),
              )
            : SliverToBoxAdapter(
                child: SizedBox.shrink(),
              ),
        SliverList(
          delegate: SliverChildListDelegate([child]),
        ),
      ],
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({required this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      height: 5.0,
      child: widget,
    );
  }

  @override
  double get maxExtent => 5.0;

  @override
  double get minExtent => 5.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
