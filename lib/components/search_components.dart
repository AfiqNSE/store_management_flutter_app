import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class PalletSearch extends StatefulWidget {
  final EdgeInsets padding;
  final TextEditingController controller;
  final bool enabled;
  final Function(String value) onSearch;
  final Duration waitTime;
  final bool activePalletOnly;

  const PalletSearch({
    super.key,
    this.padding = const EdgeInsets.all(0),
    required this.controller,
    this.enabled = true,
    this.waitTime = const Duration(seconds: 1),
    required this.onSearch,
    this.activePalletOnly = false,
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
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.grey.shade200,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 0),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 0),
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8, right: 4),
            child: Icon(
              FluentIcons.search_24_filled,
              color: Colors.grey.shade500,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minHeight: 26,
            minWidth: 26,
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

          if (!widget.activePalletOnly) {
            if (stopTyping != null) {
              stopTyping!.cancel();
            }

            if (value.length < 3) {
              return;
            }

            stopTyping = Timer(widget.waitTime, () {
              widget.onSearch(value);
            });
          }

          if (value == "") {
            return;
          }
        },
        onSubmitted: (value) {
          // Only for Pallet view
          if (widget.activePalletOnly) {
            widget.controller.clear();
          }

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
