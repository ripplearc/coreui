import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// How a [CoreAppBar] separates itself from the content scrolling beneath it.
enum CoreAppBarElevation {
  /// No shadow at all. Use for bars that sit flush on the page background,
  /// such as the auth screens' bars.
  none,

  /// A [CoreShadows.medium] shadow painted by the bar's own decoration.
  ///
  /// Material elevation is held at zero so the shadow is drawn exactly once.
  shadow,

  /// Material's own elevation shadow, tinted by the theme's shadow color.
  ///
  /// Prefer [shadow]; this exists for surfaces that must match a
  /// Material-elevated sibling.
  material,
}

/// Top app bar wired to the CoreUI theme, usable directly as [Scaffold.appBar].
///
/// Wraps a Material [AppBar] in a decorated container so the separating shadow
/// comes from [CoreShadows] rather than Material elevation. Drawing it once,
/// from one place, avoids the doubled shadow you get when an elevated [AppBar]
/// sits inside an already-shadowed container.
///
/// ### Sizing
/// [height] is the bar's *content* height — the space the title, leading
/// widget, and actions are laid out in. [padding] is added around that content
/// and is therefore *additive* to [preferredSize]:
///
/// ```text
/// preferredSize.height == height + padding.vertical
/// ```
///
/// This is deliberate. Folding padding into a fixed preferred size silently
/// shrinks the content box, which is how tap targets end up under the 48x48
/// guideline. Because [height] is never eaten by padding, an action icon
/// always has at least [height] of vertical room. The constructor asserts
/// [height] is at least [CoreSpacing.space12] (48) to keep that guarantee.
///
/// The status bar inset is handled by the inner [AppBar] and is not part of
/// [preferredSize]; [Scaffold] adds it separately, so the bar's background and
/// shadow extend behind the status bar as expected.
///
/// ### Where the defaults come from
/// Measured from the app bars in the consuming app, not chosen freehand:
///
/// | Bar                          | Preferred | Container padding | Separation |
/// |------------------------------|-----------|-------------------|------------|
/// | Auth back bars (x4)          | 56        | none              | none       |
/// | `TitleSearchAppBar`          | 56        | h16 v8            | shadow     |
/// | `ProjectHeaderAppBar` (both) | 56        | h16 (v8 initial)  | shadow     |
/// | Search bars (x2)             | 56        | none              | none       |
/// | `ProjectCreationScreen`      | 56        | none              | material   |
/// | `HeaderRow`                  | 64        | l4 r16            | shadow     |
/// | Estimation bars (x2)         | 61        | none              | shadow     |
///
/// 56 is the dominant preferred size, hence the [height] default. The two
/// estimation bars use `kToolbarHeight + 5`; 61 is not on the 4px token grid
/// and should settle on [CoreSpacing.space14] or [CoreSpacing.space16] when
/// they migrate.
///
/// Note that the bars applying vertical container padding are the ones whose
/// tap targets fall short — 56 preferred minus 8+8 padding leaves a 40px
/// content box. Additive padding is what removes that failure mode here.
///
/// Caveat: the table measures the consuming app's *code*, not the design
/// spec. The reusable "Action Bar" component in the Figma file measures
/// 412x64 — total height [CoreSpacing.space16] — with baked-in padding of
/// t8/b8/l4/r16 (a 48px content box) on every screen it appears on. The
/// code-derived defaults here (56 tall, zero padding) are therefore 8px
/// shorter and un-padded relative to Figma's dominant top-bar pattern. Sites
/// migrating under CA-823 should pass `height`/`padding` explicitly (or this
/// default should be revisited) rather than silently inheriting the 56px
/// default as a match for the spec.
///
/// ### Theming
/// Colors come from [AppColorsExtension] (`pageBackground`, `textHeadline`) and
/// typography from [AppTypographyExtension] (`titleMediumSemiBold`), so the bar
/// tracks both [CoreTheme.light] and [CoreTheme.dark] without per-site work.
///
/// The bar sets an `iconTheme` of `iconDark`, which reaches material-glyph
/// [CoreIconWidget]s that were given no explicit `color`. SVG-backed icons are
/// left untinted — [CoreIconWidget] applies no color filter when `color` is
/// null — which keeps brand marks their own color but means an SVG action
/// needs an explicit `color` if it should follow the theme.
///
/// ### Accessibility
/// [CoreAppBar] renders whatever [leading] and [actions] widgets it is given
/// and does not inject labels of its own. Pass `semanticLabel` on the
/// [CoreIconWidget]s you supply — the package holds no user-visible strings, so
/// localization stays with the consuming app.
///
/// ---
/// ## Examples
///
/// ### 1) Flat bar, no shadow
/// ```dart
/// Scaffold(
///   appBar: CoreAppBar(
///     titleText: context.l10n.resetPasswordTitle,
///     elevation: CoreAppBarElevation.none,
///   ),
///   body: ...,
/// )
/// ```
///
/// A screen that genuinely needs a close or back affordance passes it in
/// explicitly; the bar never conjures one on its own:
/// ```dart
/// CoreAppBar(
///   leading: CoreIconWidget(
///     icon: CoreIcons.cross,
///     padding: const EdgeInsets.all(CoreSpacing.space4),
///     semanticLabel: context.l10n.closeLabel,
///     onTap: router.pop,
///   ),
/// )
/// ```
///
/// ### 2) Title and actions
/// ```dart
/// CoreAppBar(
///   titleText: context.l10n.appTitle,
///   centerTitle: true,
///   padding: const EdgeInsets.symmetric(
///     horizontal: CoreSpacing.space4,
///     vertical: CoreSpacing.space2,
///   ),
///   actions: [
///     CoreIconWidget(
///       icon: CoreIcons.search,
///       semanticLabel: context.l10n.searchSemanticLabel,
///       onTap: _onSearchTap,
///     ),
///   ],
/// )
/// ```
///
/// ### 3) Custom title row
/// ```dart
/// CoreAppBar(
///   height: CoreSpacing.space16,
///   titleSpacing: 0,
///   padding: const EdgeInsets.only(
///     left: CoreSpacing.space1,
///     right: CoreSpacing.space4,
///   ),
///   title: Row(children: [...project selector...]),
///   actions: [...icon cluster...],
/// )
/// ```
///
class CoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The widget laid out in the bar's title slot.
  ///
  /// Use this for anything richer than a string — a project selector row, a
  /// custom cluster. Mutually exclusive with [titleText].
  final Widget? title;

  /// Convenience title rendered with `titleMediumSemiBold` in `textHeadline`.
  ///
  /// Mutually exclusive with [title]; supply the widget form when you need
  /// control over styling or layout.
  final String? titleText;

  /// The widget shown before the title, typically a close or back icon.
  ///
  /// Always rendered when provided, independently of [implyLeading].
  final Widget? leading;

  /// Whether Material may supply its own back button when [leading] is null
  /// and the route can be popped.
  ///
  /// Defaults to false: a bar carries no back button unless the caller asks
  /// for one, because the app bar design does not include one. Leaving this
  /// true would make the bar sprout a back button on any pushed route.
  final bool implyLeading;

  /// The widgets shown after the title, typically an icon cluster.
  final List<Widget> actions;

  /// Whether the title is centered rather than aligned to the leading edge.
  final bool centerTitle;

  /// How the bar separates itself from the content beneath it.
  final CoreAppBarElevation elevation;

  /// The height of the bar's content box, excluding [padding].
  ///
  /// Defaults to [CoreSpacing.space14] (56), matching Material's
  /// `kToolbarHeight`. Must be at least [CoreSpacing.space12] (48) so action
  /// and leading tap targets can meet the platform guideline.
  final double height;

  /// The horizontal gap between the leading widget and the title.
  ///
  /// Pass zero when the title supplies its own leading padding.
  final double? titleSpacing;

  /// Padding around the bar's content box.
  ///
  /// Added to [preferredSize] rather than subtracted from [height], so it
  /// never shrinks the space available to the content.
  final EdgeInsetsGeometry padding;

  /// The bar's background color.
  ///
  /// Defaults to the theme's `pageBackground`.
  final Color? backgroundColor;

  const CoreAppBar({
    super.key,
    this.title,
    this.titleText,
    this.leading,
    this.implyLeading = false,
    this.actions = const [],
    this.centerTitle = false,
    this.elevation = CoreAppBarElevation.shadow,
    this.height = CoreSpacing.space14,
    this.titleSpacing,
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
  })  : assert(
          title == null || titleText == null,
          'CoreAppBar takes either title or titleText, not both',
        ),
        assert(
          height >= CoreSpacing.space12,
          'CoreAppBar height must be at least CoreSpacing.space12 (48) so '
          'leading and action tap targets can meet the 48x48 guideline',
        );

  static const double _materialElevation = 2.0;

  @override
  Size get preferredSize => Size.fromHeight(height + padding.vertical);

  /// The shadow the bar's decoration paints, resolved from [elevation].
  ///
  /// This is what [build] hands to the container's [BoxDecoration], exposed so
  /// tests can assert the resolved shadow without reaching into the widget
  /// tree for the decorated container.
  @visibleForTesting
  List<BoxShadow>? get decorationShadow =>
      elevation == CoreAppBarElevation.shadow ? CoreShadows.medium : null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.coreColors;
    final typography = theme.coreTypography;
    final barColor = backgroundColor ?? colors.pageBackground;
    final isMaterial = elevation == CoreAppBarElevation.material;

    final label = titleText;
    final resolvedTitle = title ??
        (label == null
            ? null
            : Text(
                label,
                style: typography.titleMediumSemiBold
                    .copyWith(color: colors.textHeadline),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ));

    return Container(
      decoration: BoxDecoration(
        color: barColor,
        boxShadow: decorationShadow,
      ),
      padding: padding,
      child: AppBar(
        backgroundColor: barColor,
        // Held at zero for none/shadow so the separating shadow is drawn once,
        // by this widget's decoration, rather than twice.
        elevation: isMaterial ? _materialElevation : 0,
        // Always zero: the bar should not darken or re-tint when content
        // scrolls under it, in any elevation mode.
        scrolledUnderElevation: 0,
        shadowColor: isMaterial ? colors.shadowGrey10 : null,
        surfaceTintColor: colors.transparent,
        toolbarHeight: height,
        automaticallyImplyLeading: implyLeading,
        leading: leading,
        title: resolvedTitle,
        centerTitle: centerTitle,
        titleSpacing: titleSpacing,
        actions: actions,
        iconTheme: IconThemeData(color: colors.iconDark),
      ),
    );
  }
}
