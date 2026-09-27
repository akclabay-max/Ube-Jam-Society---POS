# ── Flutter engine and embedding ──────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# ── Your app ──────────────────────────────────────
-keep class com.example.pos.** { *; }

# ── SQLite (Drift) ────────────────────────────────
-keep class com.tekartik.sqflite.** { *; }
-keep class org.sqlite.** { *; }
-keep class org.sqlite.database.** { *; }

# ── Drift + Turso / PowerSync ─────────────────────
-keep class com.tursodatabase.** { *; }
-keep class com.powersync.** { *; }
-keep class com.powersync.** { *; }
-dontwarn com.tursodatabase.**

# ── File pickers / camera ─────────────────────────
-keep class com.baseflow.** { *; }
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# ── share_plus ────────────────────────────────────
-keep class dev.fluttercommunity.plus.share.** { *; }
-keep class dev.fluttercommunity.plus.** { *; }

# ── path_provider ─────────────────────────────────
-keep class io.flutter.plugins.pathprovider.** { *; }

# ── Play Core (deferred components — unused) ──────
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**