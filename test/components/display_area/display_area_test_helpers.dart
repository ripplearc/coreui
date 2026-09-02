/// Test-localized strings for [CoreDisplayArea].
///
/// CA-654 made `closeSemanticLabel` and `historyPlaceholder` required and
/// deleted the English defaults, so every test call site has to supply them.
/// They live here rather than as literals at ~97 call sites across four files
/// so changing the text tests exercise stays a one-line edit — the same
/// single-source-of-truth the production change was made to get.
///
/// The values match the strings the deleted defaults used, which is what keeps
/// the existing goldens byte-identical.
library;

const String testCloseSemanticLabel = 'Close';
const String testHistoryPlaceholder = 'Here will show what you type';
