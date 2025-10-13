<#-- Mermaid Js macro integration  :
 #      - Call @importMermaidJs first
 #      - create a DIV like <div class="mermaid" >graph TD (...)</div>
 #      - Call @initMermaidJs
-->
<#macro importMermaidJs zoom=true>
<#if mermaidIsLoaded?? && mermaidIsLoaded>
<#else>
<script src="js/admin/lib/mermaid/mermaid.min.js"></script>
<#if zoom>
<script src="js/admin/lib/mermaid/svg-pan-zoom.js"></script>
<style>
#pane-graph .mermaid{
 animation: mermaid-in  .5s ease-in-out .5s forwards;
}

@keyframes  mermaid-in {
       0% {
              filter: blur(4px);
              opacity: 0;
       }
       100% {
              filter: blur(0px);
              opacity: 1;
       }
}
</style>
</#if>
</#if>
<#assign mermaidIsLoaded = true />
</#macro>
<#macro initMermaidJs zoom=true diagramName='diagram'>
<#if mermaidIsInitialized?? && mermaidIsInitialized>
<#else>
<style>
[id*="mermaid-"]:hover{
 cursor: grab;
}
</style>
<script>
// Zoom management
window.onload = function() {
       var config = {
              startOnLoad:true,
              securityLevel:'loose',
       };
       mermaid.initialize(config);
       <#if zoom>
       window.mermaidZoom = svgPanZoom('[id*="mermaid-"]', {
              zoomEnabled: true,
              controlIconsEnabled: false,
              fit: true,
              // center: true,
       });
       document.getElementById('zoom-in').addEventListener('click', function(ev){
              ev.preventDefault()
              mermaidZoom.zoomIn()
       });

       document.getElementById('zoom-out').addEventListener('click', function(ev){
              ev.preventDefault()
              mermaidZoom.zoomOut()
       });

       document.getElementById('reset').addEventListener('click', function(ev){
              ev.preventDefault()
              mermaidZoom.resetZoom()
       });
</#if>
};

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
                     const fileName = nameInput ? nameInput.value : '${diagramName}.svg';
                     btn.setAttribute("download", fileName);
              });
       });
});
</script>
</#if>
<#assign mermaidIsInitialized = true />
</#macro> 
<#macro mermaidGraph mdgraph=mdgraph zoomControls=true zoomPos='top' zoomAlign='end' download=true>
<#local align='justify-content-${zoomAlign}' />
<#if zoomPos='top'>
<@div class='d-flex ${align} '>
<#if zoomControls><@mermaidToolBar /></#if>
<#if download><@link href='' class='btn btn-info download-button' label='#i18n{mermaidjs.download.title}' title='#i18n{mermaidjs.download.title}' target='_blank' params='download' /></#if>
</@div>
</#if>
<@div class='mermaid'>
${mdgraph}
<#nested />
</@div>
<#if zoomPos !='top'>
<@div class='d-flex ${align}'>
<#if zoomControls ><@mermaidToolBar /></#if>
<#if download><@link href='' class='btn btn-info download-button' label='#i18n{mermaidjs.download.title}' title='#i18n{mermaidjs.download.title}' target='_blank' params='download' /></#if>
</@div>
</#if>
</#macro> 
<#macro mermaidToolBar>
<@button color='default' id='zoom-in' title='#i18n{mermaidjs.zoomIn}' buttonIcon='search-minus'  />
<@button color='default' id='zoom-out' title='#i18n{mermaidjs.zoomOut}'  buttonIcon='search-plus' />
<@button color='default' id='reset' title='#i18n{mermaidjs.reset}' buttonIcon='search' />
</#macro> 
<#macro mermaidHelp zoom=true download=true>
<@box class='text-white bg-info'>
<@boxHeader title='#i18n{mermaidjs.help.title}'  />
<@boxBody class='text-dark'>
<@ul>
<@li>
#i18n{mermaidjs.help.info}
<#if zoom> #i18n{mermaidjs.help.zoom}</#if>
<#if download> #i18n{mermaidjs.help.download}</#if>
</@li>
</@ul>
</@boxBody>
</@box>
</#macro> 