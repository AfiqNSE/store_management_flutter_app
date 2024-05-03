import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class PalletSearch extends StatefulWidget {
  final EdgeInsets padding;
  final TextEditingController controller;
  final bool enabled;
  final Duration waitTime;
  final Function(String value) onSearch;

  const PalletSearch({
    super.key,
    this.padding = const EdgeInsets.all(0),
    required this.controller,
    this.enabled = true,
    this.waitTime = const Duration(seconds: 1),
    required this.onSearch,
  });

  @override
  State<PalletSearch> createState() => _PalletSearchState();
}

class _PalletSearchState extends State<PalletSearch> {
  Timer? stopTyping;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: TextField(
        controller: widget.controller,
        autofocus: true,
        enabled: widget.enabled,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.grey.shade200,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 0),
            borderRadius: BorderRadius.circular(30),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 0),
            borderRadius: BorderRadius.circular(30),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8, right: 4),
            child: Icon(
              FluentIcons.search_24_filled,
              color: Colors.grey.shade500,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minHeight: 24,
            minWidth: 24,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          hintText: "Search Pallet...",
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.normal,
          ),
          suffixIcon: (widget.controller.text != "")
              ? SizedBox.shrink(
                  child: IconButton(
                    padding: const EdgeInsets.only(right: 8),
                    icon: const Icon(FluentIcons.dismiss_circle_24_filled),
                    iconSize: 20,
                    color: Colors.grey.shade500,
                    onPressed: () {
                      setState(() {
                        widget.controller.clear();
                      });
                    },
                  ),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(
            minHeight: 24,
            minWidth: 32,
          ),
        ),
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          setState(() {});

          if (stopTyping != null) {
            stopTyping!.cancel();
          }

          if (value == "") {
            return;
          }

          if (value.length < 4) {
            return;
          }

          stopTyping = Timer(widget.waitTime, () {
            widget.onSearch(value);
          });
        },
        onSubmitted: (value) {
          if (stopTyping != null) {
            stopTyping!.cancel();
          }

          if (value == "") {
            return;
          }

          widget.onSearch(value);
        },
      ),
    );
  }
}
