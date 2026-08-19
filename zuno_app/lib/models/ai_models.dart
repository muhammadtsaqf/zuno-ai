class AiModelInfo {
  final String id;
  final String displayName;
  final String provider;
  final String description;

  const AiModelInfo({
    required this.id,
    required this.displayName,
    required this.provider,
    required this.description,
  });
}

class AiModels {
  static const String zunoPro = 'zuno-pro';
  static const String qwenMax = 'qd/qmodel_38max';
  static const String geminiFlash = 'ag/gemini-3.6-flash-high';
  static const String claudeSonnet = 'ag/claude-sonnet-4-6';
  static const String claudeOpus = 'ag/claude-opus-4-6-thinking';

  static const List<AiModelInfo> availableModels = [
    AiModelInfo(
      id: zunoPro,
      displayName: 'Zuno Pro (Default)',
      provider: 'Zuno AI Hybrid Engine',
      description: 'Model gabungan super cerdas (Qwen + Gemini + Claude) dengan Persona Zuno',
    ),
    AiModelInfo(
      id: qwenMax,
      displayName: 'Qwen Max 3.8',
      provider: 'Alibaba / Qwen',
      description: 'Raw Model: Respons cepat & kemampuan serba tahu presisi tanpa system prompt',
    ),
    AiModelInfo(
      id: geminiFlash,
      displayName: 'Gemini 3.6 Flash High',
      provider: 'Google Gemini',
      description: 'Raw Model: Kecepatan kilat dengan reasoning murni',
    ),
    AiModelInfo(
      id: claudeSonnet,
      displayName: 'Claude Sonnet 4.6',
      provider: 'Anthropic Claude',
      description: 'Raw Model: Bahasa natural, mulus & analisis mendalam',
    ),
    AiModelInfo(
      id: claudeOpus,
      displayName: 'Claude Opus 4.6 Thinking',
      provider: 'Anthropic Claude',
      description: 'Raw Model: Penalaran kompleks & logika sangat canggih',
    ),
  ];

  static AiModelInfo getModelInfo(String id) {
    return availableModels.firstWhere(
      (m) => m.id == id,
      orElse: () => availableModels.first,
    );
  }
}
