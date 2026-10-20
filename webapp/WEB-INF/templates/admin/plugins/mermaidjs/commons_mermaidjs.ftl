<#-- Mermaid Js macro integration  :
 #      - Call @importMermaidJs first
 #      - create a DIV like <div class="mermaid" >graph TD (...)</div>
 #      - Call @initMermaidJs
 # @mermaidGraph: mdgraph is the Mermaid source, a text value written escaped (Mermaid reads the decoded text);
 #      toolbarBtn is markup (a capture <#assign x>...</#assign> or a HtmlMarkup): a string is written as text.
-->
<#macro importMermaidJs zoom=true deprecated...>
<@deprecatedWarning args=deprecated />
<#if mermaidIsLoaded?? && mermaidIsLoaded>
<#else>
<script src="js/admin/lib/mermaid/mermaid.min.js"></script>
<#if zoom>
<script src="js/admin/lib/mermaid/svg-pan-zoom.js"></script>
<style>
#pane-graph .mermaid{
 animation: mermaid-in 2s ease-in;
}

@keyframes  mermaid-in {
   0% {
       filter: blur(4px);
       opacity: 0;
  }
  100% {
       filter: blur(0);
       opacity: 1;
   }
}

.mermaid > svg:hover{
       cursor: grab;
}
</style>
</#if>
</#if>
<#assign mermaidIsLoaded = true />
</#macro>
<#macro initMermaidJs zoom=true diagramName='diagram' deprecated...>
<@deprecatedWarning args=deprecated />
<#if mermaidIsInitialized?? && mermaidIsInitialized>
<#else>
<script>
// Mermaid renders asynchronously: disable the automatic rendering on load and run it explicitly,
// then attach the zoom to the rendered SVG.
mermaid.initialize({
       startOnLoad: false,
       securityLevel: 'strict',
       layout: 'dagre',
       theme: 'default',
       look: 'classic',
});

window.addEventListener('load', function() {
       mermaid.run({ querySelector: '.mermaid' }).then(function() {
<#if zoom>
              const svg = document.querySelector('.mermaid > svg');
              if (!svg) return;
              // svg-pan-zoom drops the viewBox the height is computed from: keep the diagram height
              if (!svg.getAttribute('height') && svg.viewBox.baseVal) {
                     svg.setAttribute('height', svg.viewBox.baseVal.height);
              }
              window.mermaidZoom = svgPanZoom(svg, {
                     zoomEnabled: true,
                     controlIconsEnabled: false,
                     fit: true,
              });
              const bindZoom = function(id, action) {
                     const btn = document.getElementById(id);
                     if (!btn) return;
                     btn.addEventListener('click', function(ev) {
                            ev.preventDefault();
                            action();
                     });
              };
              bindZoom('zoom-in', function() { mermaidZoom.zoomIn(); });
              bindZoom('zoom-out', function() { mermaidZoom.zoomOut(); });
              bindZoom('reset', function() { mermaidZoom.resetZoom(); });
</#if>
       }).catch(function(err) {
              console.error('Mermaid rendering failed', err);
       });
});

// This SVG data is copied from
// A data URL can also be generated from an existing SVG element.
function svgDataURL(svg) {
       const svgAsXML = (new XMLSerializer).serializeToString(svg);
       return "data:image/svg+xml," + encodeURIComponent(svgAsXML);
}

document.addEventListener('DOMContentLoaded', function() {
       document.querySelectorAll('.download-button').forEach(function(btn) {
              btn.addEventListener('click', function(e) {
                     const svg = document.querySelector('.mermaid > svg');
                     if (!svg) return;
                     btn.setAttribute("href", svgDataURL(svg));
                     const nameInput = document.querySelector('[name="name"]');
                     const fileName = nameInput ? nameInput.value : '${diagramName?js_string?no_esc}.svg';
                     btn.setAttribute("download", fileName);
              });
       });
       document.querySelectorAll('.mermaid').forEach(function(mermaid) {
              mermaid.classList.remove('d-none');
       });
});
</script>
</#if>
<#assign mermaidIsInitialized = true />
</#macro> 
<#macro mermaidGraph mdgraph=mdgraph zoomControls=true zoomPos='start' zoomAlign='end' toolbarBtn='' download=true  deprecated...>
<@deprecatedWarning args=deprecated />
<#local align='justify-content-${zoomAlign}' />
<#local valign='align-items-${zoomPos}' />
<@row>
       <@columns xs=12 md=11>
              <@div class='mermaid w-100 d-none'>${mdgraph}</@div>
              <#nested />
       </@columns>
       <@columns>
              <@div class='d-flex ${align} ${valign}'>
                     <#if zoomControls><@mermaidToolBar zoom=zoomControls download=download toolbarBtn=toolbarBtn /></#if>
                     <#if download><@link href='' class='btn btn-info download-button' label='#i18n{mermaidjs.download.title}' title='#i18n{mermaidjs.download.title}' target='_blank' params={"download": true} /></#if>
              </@div>
       </@columns>
</@row>
</#macro> 
<#macro mermaidToolBar zoom=true download=true toolbarBtn='' deprecated...>
<@deprecatedWarning args=deprecated />
<#local helpMsg><ul><li>#i18n{mermaidjs.help.info}</li><#if zoom><li>#i18n{mermaidjs.help.zoom}</li></#if><#if download><li>#i18n{mermaidjs.help.download}</li></#if></ul></#local>
<@btnToolbar class='mb-3' vertical=true>
<#if toolbarBtn?has_content>${toolbarBtn}</#if>
  <@button color='secondary' id='zoom-in' title='#i18n{mermaidjs.zoomIn}' buttonIcon='zoom-out' hideTitle=['all'] />
  <@button color='secondary' id='zoom-out' title='#i18n{mermaidjs.zoomOut}'  buttonIcon='zoom-in' hideTitle=['all'] />
  <@button color='secondary' id='reset' title='#i18n{mermaidjs.reset}' buttonIcon='zoom-cancel' hideTitle=['all'] />
  <@button color='secondary' title='#i18n{mermaidjs.help.title}' buttonIcon='help-circle' hideTitle=['all']  params={"data-bs-container": "body", "data-bs-toggle": "popover", "data-bs-html": "true", "data-bs-placement": "bottom", "data-bs-content": helpMsg} />
</@btnToolbar>
</#macro> 
<#macro mermaidHelp zoom=true download=true deprecated...>
<@deprecatedWarning args=deprecated />
<@accordion id='mermaidHelp' title='#i18n{mermaidjs.help.title}' headerClass='h5' icon='help-circle' collapsed=true>
<ul><li>#i18n{mermaidjs.help.info}</li><#if zoom><li>#i18n{mermaidjs.help.zoom}</li></#if><#if download><li>#i18n{mermaidjs.help.download}</li></#if></ul>
</@accordion>
</#macro> 