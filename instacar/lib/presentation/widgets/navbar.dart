import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instacar/presentation/widgets/topChatButton.dart';
import 'package:instacar/presentation/widgets/home_modal_add.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TopNavbar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final bool showFilter; // New parameter
  final Function(Map<String, dynamic>)? onFilterApplied; // New parameter for filter callback
  final bool showRequestsButton; // New parameter for requests button
  final bool showSearch; // Controla exibição da barra de busca

  const TopNavbar({
    super.key,
    required this.onSearchChanged,
    this.showFilter = true, // Default is true
    this.onFilterApplied,
    this.showRequestsButton = false, // Default is false
    this.showSearch = true, // Default é mostrar a busca
  });

  @override
  State<TopNavbar> createState() => _TopNavbarState();
}

class _TopNavbarState extends State<TopNavbar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/instacar_escrito.png',
                    width: 160,
                    height: 30,
                  ),
                  Row(
                    children: [
                      if (widget.showRequestsButton) ...[
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(context).go('/solicitacoes');
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.blue, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.notifications_active,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      TopChatButton(
                        onTap: () {
                          GoRouter.of(context).go('/chat');
                        },
                      ),
                    ],
                  ),
                ],
              ),
              if (widget.showSearch) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: widget.onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Buscar...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    if (widget.showFilter) ...[
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.filter_list,
                            color: Colors.blue,
                            size: 24,
                          ),
                          onPressed: () {
                            showBarModalBottomSheet(
                              context: context,
                              builder: (context) => HomeModalAdd(
                                onFilterApplied: widget.onFilterApplied,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
