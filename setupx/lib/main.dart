import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';
import 'package:process_run/process_run.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure window for full-screen experience
  await windowManager.ensureInitialized();
  
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 800),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.maximize();
  });
  
  runApp(const SetupXApp());
}

class SetupXApp extends StatelessWidget {
  const SetupXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return fluent.FluentApp(
      title: 'SetupX - System Setup Automation',
      theme: fluent.FluentThemeData(
        brightness: Brightness.dark,
        accentColor: fluent.Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WindowListener {
  int selectedIndex = 0;
  
  final List<fluent.NavigationPaneItem> items = [
    fluent.PaneItem(
      icon: const Icon(fluent.FluentIcons.home),
      title: const Text('Dashboard'),
      body: const DashboardPage(),
    ),
    fluent.PaneItem(
      icon: const Icon(fluent.FluentIcons.package),
      title: const Text('Package Managers'),
      body: const PackageManagersPage(),
    ),
    fluent.PaneItem(
      icon: const Icon(fluent.FluentIcons.code),
      title: const Text('Scripts'),
      body: const ScriptsPage(),
    ),
    fluent.PaneItem(
      icon: const Icon(fluent.FluentIcons.download),
      title: const Text('Software Installation'),
      body: const SoftwareInstallationPage(),
    ),
    fluent.PaneItem(
      icon: const Icon(fluent.FluentIcons.settings),
      title: const Text('System Settings'),
      body: const SystemSettingsPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return fluent.NavigationView(
      appBar: fluent.NavigationAppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0078D4), Color(0xFF106EBE)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                fluent.FluentIcons.settings_secure,
                color: Colors.white,
                size: 18,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(width: 12),
            const Text(
              'SetupX',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
          ],
        ),
        actions: Row(
          children: [
            fluent.IconButton(
              icon: const Icon(fluent.FluentIcons.refresh),
              onPressed: () {
                // Refresh functionality
              },
            ),
            fluent.IconButton(
              icon: const Icon(fluent.FluentIcons.chrome_minimize),
              onPressed: () => windowManager.minimize(),
            ),
            fluent.IconButton(
              icon: const Icon(fluent.FluentIcons.chrome_restore),
              onPressed: () => windowManager.isMaximized().then((isMaximized) {
                if (isMaximized) {
                  windowManager.unmaximize();
                } else {
                  windowManager.maximize();
                }
              }),
            ),
            fluent.IconButton(
              icon: const Icon(fluent.FluentIcons.chrome_close),
              onPressed: () => windowManager.close(),
            ),
          ],
        ),
      ),
      pane: fluent.NavigationPane(
        selected: selectedIndex,
        onChanged: (index) => setState(() => selectedIndex = index),
        displayMode: fluent.PaneDisplayMode.open,
        items: items,
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return fluent.ScaffoldPage(
      header: const fluent.PageHeader(
        title: Text('Dashboard'),
      ),
      content: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to SetupX',
              style: fluent.FluentTheme.of(context).typography.titleLarge,
            ).animate().fadeIn().slideY(begin: -0.2),
            const SizedBox(height: 16),
            Text(
              'Automate your Windows system setup with ease',
              style: fluent.FluentTheme.of(context).typography.body,
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
                    'Package Managers',
                    'Install Chocolatey, Scoop, and Winget',
                    fluent.FluentIcons.package,
                    const Color(0xFF0078D4),
                  ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8, 0.8)),
                  _buildDashboardCard(
                    'Software Installation',
                    'Install essential software packages',
                    fluent.FluentIcons.download,
                    const Color(0xFF107C10),
                  ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.8, 0.8)),
                  _buildDashboardCard(
                    'System Settings',
                    'Configure Windows settings',
                    fluent.FluentIcons.settings,
                    const Color(0xFFFF8C00),
                  ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.8, 0.8)),
                  _buildDashboardCard(
                    'System Status',
                    'View system information',
                    fluent.FluentIcons.info,
                    const Color(0xFF5C2D91),
                  ).animate().fadeIn(delay: 1000.ms).scale(begin: const Offset(0.8, 0.8)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, String subtitle, IconData icon, Color color) {
    return fluent.Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PackageManagersPage extends StatelessWidget {
  const PackageManagersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return fluent.ScaffoldPage(
      header: const fluent.PageHeader(
        title: Text('Package Managers'),
      ),
      content: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text('Package Managers installation and management will be implemented here.'),
          ],
        ),
      ),
    );
  }
}

class SoftwareInstallationPage extends StatelessWidget {
  const SoftwareInstallationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return fluent.ScaffoldPage(
      header: const fluent.PageHeader(
        title: Text('Software Installation'),
      ),
      content: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text('Software installation functionality will be implemented here.'),
          ],
        ),
      ),
    );
  }
}

class SystemSettingsPage extends StatelessWidget {
  const SystemSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return fluent.ScaffoldPage(
      header: const fluent.PageHeader(
        title: Text('System Settings'),
      ),
      content: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text('System settings configuration will be implemented here.'),
          ],
        ),
      ),
    );
  }
}

class ScriptsPage extends StatefulWidget {
  const ScriptsPage({super.key});

  @override
  State<ScriptsPage> createState() => _ScriptsPageState();
}

class _ScriptsPageState extends State<ScriptsPage> {
  final List<ScriptInfo> scripts = [
    ScriptInfo(
      name: 'Install Chocolatey',
      description: 'Install Chocolatey package manager with PowerShell functions',
      fileName: 'install-chocolatey.ps1',
      category: 'Package Managers',
      icon: fluent.FluentIcons.package,
      color: const Color(0xFF8B4513),
    ),
    ScriptInfo(
      name: 'Install Scoop',
      description: 'Install Scoop command-line installer for Windows',
      fileName: 'install-scoop.ps1',
      category: 'Package Managers',
      icon: fluent.FluentIcons.command_prompt,
      color: const Color(0xFF4CAF50),
    ),
    ScriptInfo(
      name: 'Install WinGet',
      description: 'Install Windows Package Manager with auto-elevation',
      fileName: 'install-winget.ps1',
      category: 'Package Managers',
      icon: fluent.FluentIcons.download,
      color: const Color(0xFF0078D4),
    ),
    ScriptInfo(
      name: 'Interactive Package Manager Installer',
      description: 'Firebase CLI-style interactive menu for package manager installation',
      fileName: 'install-package-manager.ps1',
      category: 'Interactive Tools',
      icon: fluent.FluentIcons.code_edit,
      color: const Color(0xFFFF9800),
    ),
    ScriptInfo(
      name: 'Verify Package Managers',
      description: 'Comprehensive verification script for all package managers',
      fileName: 'verify-package-managers.ps1',
      category: 'Verification',
      icon: fluent.FluentIcons.completed_solid,
      color: const Color(0xFF9C27B0),
    ),
  ];

  // Group scripts by category
  Map<String, List<ScriptInfo>> get groupedScripts {
    final Map<String, List<ScriptInfo>> grouped = {};
    for (final script in scripts) {
      if (!grouped.containsKey(script.category)) {
        grouped[script.category] = [];
      }
      grouped[script.category]!.add(script);
    }
    return grouped;
  }

  // Category colors and icons
  Map<String, Color> get categoryColors => {
    'Package Managers': const Color(0xFF0078D4),
    'Interactive Tools': const Color(0xFFFF9800),
    'Verification': const Color(0xFF9C27B0),
    'System Tools': const Color(0xFF107C10),
    'Development': const Color(0xFFE74C3C),
  };

  Map<String, fluent.IconData> get categoryIcons => {
    'Package Managers': fluent.FluentIcons.package,
    'Interactive Tools': fluent.FluentIcons.code_edit,
    'Verification': fluent.FluentIcons.completed_solid,
    'System Tools': fluent.FluentIcons.settings,
    'Development': fluent.FluentIcons.developer_tools,
  };

  @override
  Widget build(BuildContext context) {
    final grouped = groupedScripts;
    
    return fluent.ScaffoldPage(
      header: const fluent.PageHeader(
        title: Text('PowerShell Scripts'),
      ),
      content: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available PowerShell Scripts',
              style: fluent.FluentTheme.of(context).typography.titleLarge,
            ).animate().fadeIn().slideY(begin: -0.2),
            const SizedBox(height: 8),
            Text(
              'Scripts organized by category - click "View" to see content, "Copy" to copy to clipboard',
              style: fluent.FluentTheme.of(context).typography.body,
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: grouped.keys.length,
                itemBuilder: (context, categoryIndex) {
                  final category = grouped.keys.elementAt(categoryIndex);
                  final categoryScripts = grouped[category]!;
                  final categoryColor = categoryColors[category] ?? const Color(0xFF666666);
                  final categoryIcon = categoryIcons[category] ?? fluent.FluentIcons.folder;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: fluent.Expander(
                      initiallyExpanded: true,
                      header: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              categoryIcon,
                              color: categoryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: categoryColor,
                                ),
                              ),
                              Text(
                                '${categoryScripts.length} script${categoryScripts.length == 1 ? '' : 's'}',
                                style: fluent.FluentTheme.of(context).typography.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                      content: Column(
                        children: categoryScripts.asMap().entries.map((entry) {
                          final index = entry.key;
                          final script = entry.value;
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: fluent.Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: script.color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        script.icon,
                                        color: script.color,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            script.name,
                                            style: fluent.FluentTheme.of(context).typography.bodyStrong,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            script.description,
                                            style: fluent.FluentTheme.of(context).typography.caption,
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: script.color.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: script.color.withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              script.fileName,
                                              style: TextStyle(
                                                color: script.color,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Row(
                                      children: [
                                        fluent.Button(
                                          onPressed: () => _copyScript(script),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(fluent.FluentIcons.copy, size: 14),
                                              SizedBox(width: 6),
                                              Text('Copy'),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        fluent.Button(
                                          onPressed: () => _downloadScript(script),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(fluent.FluentIcons.download, size: 14),
                                              SizedBox(width: 6),
                                              Text('Download'),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        fluent.FilledButton(
                                          onPressed: () => _runScript(script),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(fluent.FluentIcons.view, size: 14),
                                              SizedBox(width: 6),
                                              Text('View'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX(begin: 0.2);
                        }).toList(),
                      ),
                    ),
                  ).animate().fadeIn(delay: Duration(milliseconds: 200 * categoryIndex)).slideY(begin: 0.1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyScript(ScriptInfo script) async {
    try {
      // Determine the correct script directory based on the script name
      String scriptDirectory;
      if (script.fileName == 'install-package-manager.ps1') {
        scriptDirectory = 'windows_scripts/sub-script';
      } else if (script.fileName == 'verify-package-managers.ps1') {
        scriptDirectory = 'windows_scripts';
      } else {
        scriptDirectory = 'windows_scripts/script';
      }
      
      final scriptPath = '$scriptDirectory/${script.fileName}';
      final file = File(scriptPath);
      
      if (await file.exists()) {
        final content = await file.readAsString();
        await Clipboard.setData(ClipboardData(text: content));
        
        if (mounted) {
          fluent.displayInfoBar(
            context,
            builder: (context, close) => fluent.InfoBar(
              title: const Text('Script Copied'),
              content: Text('${script.name} has been copied to clipboard'),
              severity: fluent.InfoBarSeverity.success,
              onClose: close,
            ),
          );
        }
      } else {
        if (mounted) {
          fluent.displayInfoBar(
            context,
            builder: (context, close) => fluent.InfoBar(
              title: const Text('File Not Found'),
              content: Text('Script file ${script.fileName} not found'),
              severity: fluent.InfoBarSeverity.error,
              onClose: close,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        fluent.displayInfoBar(
          context,
          builder: (context, close) => fluent.InfoBar(
            title: const Text('Copy Failed'),
            content: Text('Failed to copy script: $e'),
            severity: fluent.InfoBarSeverity.error,
            onClose: close,
          ),
        );
      }
    }
  }

  Future<void> _downloadScript(ScriptInfo script) async {
    try {
      // Determine the correct script directory based on the script name
      String scriptDirectory;
      if (script.fileName == 'install-package-manager.ps1') {
        scriptDirectory = 'windows_scripts/sub-script';
      } else if (script.fileName == 'verify-package-managers.ps1') {
        scriptDirectory = 'windows_scripts';
      } else {
        scriptDirectory = 'windows_scripts/script';
      }
      
      final scriptPath = '$scriptDirectory/${script.fileName}';
      final file = File(scriptPath);
      
      if (await file.exists()) {
        // For now, we'll copy to clipboard as download functionality 
        // would require additional platform-specific implementation
        final content = await file.readAsString();
        await Clipboard.setData(ClipboardData(text: content));
        
        if (mounted) {
          fluent.displayInfoBar(
            context,
            builder: (context, close) => fluent.InfoBar(
              title: const Text('Script Ready'),
              content: Text('${script.name} copied to clipboard. Save it as ${script.fileName}'),
              severity: fluent.InfoBarSeverity.info,
              onClose: close,
            ),
          );
        }
      } else {
        if (mounted) {
          fluent.displayInfoBar(
            context,
            builder: (context, close) => fluent.InfoBar(
              title: const Text('File Not Found'),
              content: Text('Script file ${script.fileName} not found'),
              severity: fluent.InfoBarSeverity.error,
              onClose: close,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        fluent.displayInfoBar(
          context,
          builder: (context, close) => fluent.InfoBar(
            title: const Text('Download Failed'),
            content: Text('Failed to prepare script: $e'),
            severity: fluent.InfoBarSeverity.error,
            onClose: close,
          ),
        );
      }
    }
  }

  Future<void> _runScript(ScriptInfo script) async {
    try {
      // Determine the correct script directory based on the script name
      String scriptDirectory;
      if (script.fileName == 'install-package-manager.ps1') {
        scriptDirectory = 'windows_scripts/sub-script';
      } else if (script.fileName == 'verify-package-managers.ps1') {
        scriptDirectory = 'windows_scripts';
      } else {
        scriptDirectory = 'windows_scripts/script';
      }
      
      final scriptPath = '$scriptDirectory/${script.fileName}';
      final file = File(scriptPath);
      
      if (await file.exists()) {
        final content = await file.readAsString();
        
        if (mounted) {
          // Show script content in a dialog instead of executing
          await fluent.showDialog<void>(
            context: context,
            builder: (context) => fluent.ContentDialog(
              title: Row(
                children: [
                  Icon(
                    script.icon,
                    color: script.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('${script.name} - Script Content'),
                ],
              ),
              content: SizedBox(
                width: 600,
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: script.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            fluent.FluentIcons.info,
                            size: 16,
                            color: script.color,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              script.description,
                              style: TextStyle(
                                color: script.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'File: ${script.fileName}',
                      style: fluent.FluentTheme.of(context).typography.caption,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            content,
                            style: const TextStyle(
                              fontFamily: 'Consolas',
                              fontSize: 12,
                              color: Color(0xFFD4D4D4),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                fluent.Button(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: content));
                    if (mounted) {
                      fluent.displayInfoBar(
                        context,
                        builder: (context, close) => fluent.InfoBar(
                          title: const Text('Copied'),
                          content: const Text('Script content copied to clipboard'),
                          severity: fluent.InfoBarSeverity.success,
                          onClose: close,
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(fluent.FluentIcons.copy, size: 16),
                      SizedBox(width: 8),
                      Text('Copy'),
                    ],
                  ),
                ),
                fluent.FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        }
      } else {
        if (mounted) {
          fluent.displayInfoBar(
            context,
            builder: (context, close) => fluent.InfoBar(
              title: const Text('File Not Found'),
              content: Text('Script file ${script.fileName} not found'),
              severity: fluent.InfoBarSeverity.error,
              onClose: close,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        fluent.displayInfoBar(
          context,
          builder: (context, close) => fluent.InfoBar(
            title: const Text('Error'),
            content: Text('Failed to load script: $e'),
            severity: fluent.InfoBarSeverity.error,
            onClose: close,
          ),
        );
      }
    }
  }
}

class ScriptInfo {
  final String name;
  final String description;
  final String fileName;
  final String category;
  final fluent.IconData icon;
  final Color color;

  ScriptInfo({
    required this.name,
    required this.description,
    required this.fileName,
    required this.category,
    required this.icon,
    required this.color,
  });
}
