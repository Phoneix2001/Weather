import 'package:flutter/material.dart';

import '../services/debouncer/debouncer.dart';

class AddressAutoCompleteField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isEnabled;
  final bool isError;
  final FocusNode focusNode;
  final double? errorSize;
  final void Function()? onTap;
  final void Function(String) onSelect;
  final List<String> prediction;

  final void Function(String)? onSearch;
  const AddressAutoCompleteField({
    required this.controller,
    this.onChanged,
    this.validator,
    this.isEnabled = true,
    this.isError = false,
    super.key,
    required this.focusNode,
    this.onTap,
    this.errorSize,
    required this.onSelect,
    required this.prediction,
    this.onSearch,
  });

  @override
  State<AddressAutoCompleteField> createState() =>
      _AddressAutoCompleteFieldState();
}

class _AddressAutoCompleteFieldState extends State<AddressAutoCompleteField> {
  final LayerLink _layerLink = LayerLink();

  final Debouncer _debouncer = Debouncer(
    delay: const Duration(milliseconds: 250),
  );
  final TextEditingController searchController = TextEditingController();

  List<String> _predictions = <String>[];
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (!widget.focusNode.hasFocus) {
        _removeOverlay();
      }
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    _removeOverlay();
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder:
          (BuildContext context) => StatefulBuilder(
            builder: (
              BuildContext context,
              void Function(void Function()) overlayState,
            ) {
              return Positioned(
                width: size.width,
                child: CompositedTransformFollower(
                  offset: Offset(0, size.height),
                  link: _layerLink,
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: 4,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount:
                          _predictions.length > 5 ? 5 : _predictions.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, int index) {
                        return ListTile(
                          title: Text(_predictions[index]),
                          onTap: () async {
                            widget.onSelect(_predictions[index]);
                            widget.controller.text = _predictions[index];
                            widget
                                .controller
                                .selection = TextSelection.fromPosition(
                              TextPosition(
                                offset: widget.controller.text.length,
                              ),
                            );
                            _removeOverlay();
                            if (widget.onSearch != null) {
                              widget.onSearch!(widget.controller.text);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Future<void> _onChanged(String value) async {
    widget.onChanged?.call(value);

    _debouncer.run(() async {
      if (value.isEmpty) {
        setState(() => _predictions = widget.prediction);
        _showOverlay();
        return;
      }

      try {
        final List<String> results =
            widget.prediction
                .where(
                  (element) =>
                      element.toLowerCase().startsWith(value.toLowerCase()),
                )
                .toList();

        setState(() {
          _predictions = results;
        });
        _showOverlay();
      } catch (e, s) {
        debugPrint("Prediction error: $e\nStack: $s");
      }
    });
  }

  @override
  void dispose() {
    widget.focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        autofocus: true,
        onChanged: _onChanged,
        onSubmitted: widget.onSearch,
        textInputAction: TextInputAction.search,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Enter city name...',
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
