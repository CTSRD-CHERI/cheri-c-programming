// Populate the sidebar
//
// This is a script, and not included directly in the page, to control the total size of the book.
// The TOC contains an entry for each page, so if each page includes a copy of the TOC,
// the total size of the page becomes O(n**2).
class MDBookSidebarScrollbox extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        this.innerHTML = '<ol class="chapter"><li class="chapter-item expanded affix "><a href="cover/index.html">CHERI C/C++ Programming Guide</a></li><li class="chapter-item expanded "><a href="introduction/index.html"><strong aria-hidden="true">1.</strong> Introduction</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="introduction/definitions.html"><strong aria-hidden="true">1.1.</strong> Definitions</a></li><li class="chapter-item expanded "><a href="introduction/history.html"><strong aria-hidden="true">1.2.</strong> Version history</a></li></ol></li><li class="chapter-item expanded "><a href="background/index.html"><strong aria-hidden="true">2.</strong> Background</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="background/cheri-capabilities.html"><strong aria-hidden="true">2.1.</strong> CHERI capabilities</a></li><li class="chapter-item expanded "><a href="background/architectural-rules.html"><strong aria-hidden="true">2.2.</strong> Architectural rules for capability use</a></li></ol></li><li class="chapter-item expanded "><a href="cheri-ccpp/index.html"><strong aria-hidden="true">3.</strong> CHERI C/C++</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="cheri-ccpp/cheri-runtime.html"><strong aria-hidden="true">3.1.</strong> The CHERI C/C++ run-time environment</a></li><li class="chapter-item expanded "><a href="cheri-ccpp/referential-spatial-temporal-safety.html"><strong aria-hidden="true">3.2.</strong> Referential, spatial, and temporal safety</a></li><li class="chapter-item expanded "><a href="cheri-ccpp/nonaliasing-vs-trapping.html"><strong aria-hidden="true">3.3.</strong> Non-aliasing vs trapping memory safety</a></li></ol></li><li class="chapter-item expanded "><a href="impact/index.html"><strong aria-hidden="true">4.</strong> Impact on the C/C++ programming model</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="impact/capability-faults.html"><strong aria-hidden="true">4.1.</strong> Capability-related faults</a></li><li class="chapter-item expanded "><a href="impact/pointer-provenance-validity.html"><strong aria-hidden="true">4.2.</strong> Pointer provenance validity</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="impact/recommended-use-c-types.html"><strong aria-hidden="true">4.2.1.</strong> Recommended use of C-language types</a></li><li class="chapter-item expanded "><a href="impact/capability-alignment-in-memory.html"><strong aria-hidden="true">4.2.2.</strong> Capability alignment in memory</a></li><li class="chapter-item expanded "><a href="impact/single-origin-provenance.html"><strong aria-hidden="true">4.2.3.</strong> Single-origin provenance</a></li></ol></li><li class="chapter-item expanded "><a href="impact/bounds.html"><strong aria-hidden="true">4.3.</strong> Bounds</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="impact/bounds-from-compiler.html"><strong aria-hidden="true">4.3.1.</strong> Bounds from the compiler and linker</a></li><li class="chapter-item expanded "><a href="impact/bounds-from-heap-allocator.html"><strong aria-hidden="true">4.3.2.</strong> Bounds from the heap allocator</a></li><li class="chapter-item expanded "><a href="impact/subobject-bounds.html"><strong aria-hidden="true">4.3.3.</strong> Subobject bounds</a></li></ol></li><li class="chapter-item expanded "><a href="impact/other-sources-of-bounds.html"><strong aria-hidden="true">4.4.</strong> Other sources of bounds</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="impact/out-of-bounds-pointers.html"><strong aria-hidden="true">4.4.1.</strong> Out-of-bounds pointers</a></li></ol></li><li class="chapter-item expanded "><a href="impact/pointer-comparison.html"><strong aria-hidden="true">4.5.</strong> Pointer comparison</a></li><li class="chapter-item expanded "><a href="impact/revocation.html"><strong aria-hidden="true">4.6.</strong> Implications of capability revocation for temporal safety</a></li><li class="chapter-item expanded "><a href="impact/bitwise-operations.html"><strong aria-hidden="true">4.7.</strong> Bitwise operations on capability types</a></li><li class="chapter-item expanded "><a href="impact/function-prototypes-and-calling-conventions.html"><strong aria-hidden="true">4.8.</strong> Function prototypes and calling conventions</a></li><li class="chapter-item expanded "><a href="impact/data-structure-and-memory-allocation-alignment.html"><strong aria-hidden="true">4.9.</strong> Data-structure and memory-allocation alignment</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="impact/restrictions-in-capability-locations.html"><strong aria-hidden="true">4.9.1.</strong> Restrictions in capability locations in memory</a></li></ol></li></ol></li><li class="chapter-item expanded "><a href="cheriabi/index.html"><strong aria-hidden="true">5.</strong> The CheriABI POSIX process environment</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="cheriabi/posix-api-changes.html"><strong aria-hidden="true">5.1.</strong> POSIX API changes</a></li><li class="chapter-item expanded "><a href="cheriabi/handling-capability-signals.html"><strong aria-hidden="true">5.2.</strong> Handling capability-related signals</a></li></ol></li><li class="chapter-item expanded "><a href="compiler/index.html"><strong aria-hidden="true">6.</strong> CHERI compiler warnings and errors</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="compiler/loss-of-provenance.html"><strong aria-hidden="true">6.1.</strong> Loss of provenance</a></li><li class="chapter-item expanded "><a href="compiler/ambiguous-provenance.html"><strong aria-hidden="true">6.2.</strong> Ambiguous provenance</a></li><li class="chapter-item expanded "><a href="compiler/underaligned-capabilities.html"><strong aria-hidden="true">6.3.</strong> Underaligned capabilities</a></li></ol></li><li class="chapter-item expanded "><a href="printf/index.html"><strong aria-hidden="true">7.</strong> Printing capabilities from C</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="printf/strfcap.html"><strong aria-hidden="true">7.1.</strong> Generating string representations of capabilities</a></li><li class="chapter-item expanded "><a href="printf/printf.html"><strong aria-hidden="true">7.2.</strong> Printing capabilities with the printf(3) API family</a></li></ol></li><li class="chapter-item expanded "><a href="apis/index.html"><strong aria-hidden="true">8.</strong> C APIs to get and set capability properties</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="apis/cheri-related-header-files.html"><strong aria-hidden="true">8.1.</strong> CHERI-related header files</a></li><li class="chapter-item expanded "><a href="apis/retrieving-capability-properties.html"><strong aria-hidden="true">8.2.</strong> Retrieving capability properties</a></li><li class="chapter-item expanded "><a href="apis/modifying-or-restricting-capability-properties.html"><strong aria-hidden="true">8.3.</strong> Modifying or restricting capability properties</a></li><li class="chapter-item expanded "><a href="apis/capability-permissions.html"><strong aria-hidden="true">8.4.</strong> Capability permissions</a></li><li class="chapter-item expanded "><a href="apis/bounds-alignment-due-to-compression.html"><strong aria-hidden="true">8.5.</strong> Bounds alignment due to compression</a></li><li class="chapter-item expanded "><a href="apis/implications-for-memory-allocator-design.html"><strong aria-hidden="true">8.6.</strong> Implications for memory-allocator design</a></li></ol></li><li class="chapter-item expanded "><a href="temporal-apis/index.html"><strong aria-hidden="true">9.</strong> C APIs for temporal safety</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="temporal-apis/malloc_revoke_enabled.html"><strong aria-hidden="true">9.1.</strong> Checking whether heap revocation is enabled</a></li><li class="chapter-item expanded "><a href="temporal-apis/malloc_revoke_quarantine_force_flush.html"><strong aria-hidden="true">9.2.</strong> Forcing revocation of outstanding freed pointers</a></li></ol></li><li class="chapter-item expanded "><a href="reading/index.html"><strong aria-hidden="true">10.</strong> Further reading</a></li><li class="chapter-item expanded "><a href="acks/index.html"><strong aria-hidden="true">11.</strong> Acknowledgements</a></li></ol>';
        // Set the current, active page, and reveal it if it's hidden
        let current_page = document.location.href.toString().split("#")[0];
        if (current_page.endsWith("/")) {
            current_page += "index.html";
        }
        var links = Array.prototype.slice.call(this.querySelectorAll("a"));
        var l = links.length;
        for (var i = 0; i < l; ++i) {
            var link = links[i];
            var href = link.getAttribute("href");
            if (href && !href.startsWith("#") && !/^(?:[a-z+]+:)?\/\//.test(href)) {
                link.href = path_to_root + href;
            }
            // The "index" page is supposed to alias the first chapter in the book.
            if (link.href === current_page || (i === 0 && path_to_root === "" && current_page.endsWith("/index.html"))) {
                link.classList.add("active");
                var parent = link.parentElement;
                if (parent && parent.classList.contains("chapter-item")) {
                    parent.classList.add("expanded");
                }
                while (parent) {
                    if (parent.tagName === "LI" && parent.previousElementSibling) {
                        if (parent.previousElementSibling.classList.contains("chapter-item")) {
                            parent.previousElementSibling.classList.add("expanded");
                        }
                    }
                    parent = parent.parentElement;
                }
            }
        }
        // Track and set sidebar scroll position
        this.addEventListener('click', function(e) {
            if (e.target.tagName === 'A') {
                sessionStorage.setItem('sidebar-scroll', this.scrollTop);
            }
        }, { passive: true });
        var sidebarScrollTop = sessionStorage.getItem('sidebar-scroll');
        sessionStorage.removeItem('sidebar-scroll');
        if (sidebarScrollTop) {
            // preserve sidebar scroll position when navigating via links within sidebar
            this.scrollTop = sidebarScrollTop;
        } else {
            // scroll sidebar to current active section when navigating via "next/previous chapter" buttons
            var activeSection = document.querySelector('#sidebar .active');
            if (activeSection) {
                activeSection.scrollIntoView({ block: 'center' });
            }
        }
        // Toggle buttons
        var sidebarAnchorToggles = document.querySelectorAll('#sidebar a.toggle');
        function toggleSection(ev) {
            ev.currentTarget.parentElement.classList.toggle('expanded');
        }
        Array.from(sidebarAnchorToggles).forEach(function (el) {
            el.addEventListener('click', toggleSection);
        });
    }
}
window.customElements.define("mdbook-sidebar-scrollbox", MDBookSidebarScrollbox);
