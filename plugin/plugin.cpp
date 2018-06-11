#include <maya/MFnPlugin.h>

#include "viewportRenderer.h"
#include "cmd.h"

#include <memory>

PXR_NAMESPACE_USING_DIRECTIVE

MStatus initializePlugin(MObject obj) {
    MFnPlugin plugin(obj, "Luma Pictures", "2018", "Any");
    MStatus ret = MS::kSuccess;

    auto* vp = HdMayaViewportRenderer::getInstance();
    if (vp && !vp->registerRenderer()) {
        ret = MS::kFailure;
        ret.perror("Error registering hd viewport renderer!");
        HdMayaViewportRenderer::cleanup();
    }

    plugin.registerCommand(MString("hdmaya"), HdMayaCmd::creator, HdMayaCmd::createSyntax);

    return ret;
}


MStatus uninitializePlugin(MObject obj) {
    MFnPlugin plugin(obj, "Luma Pictures", "2018", "Any");
    MStatus ret = MS::kSuccess;

    auto* vp = HdMayaViewportRenderer::getInstance();
    if (vp && vp->deregisterRenderer()) {
        ret = MS::kFailure;
        ret.perror("Error deregistering hd viewport renderer!");
    }
    HdMayaViewportRenderer::cleanup();

    plugin.deregisterCommand(MString("hdmaya"));

    return ret;
}
