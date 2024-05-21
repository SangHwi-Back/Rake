function getDOMTree(element) {
    if (element.nodeType !== Node.ELEMENT_NODE) {
        return null;
    }
    
    let attributes = {};
    for (let i = 0; i < element.attributes.length; i++) {
        attributes[element.attributes[i].name] = element.attributes[i].value;
    }

    let tree = {
        name: element.tagName,
        attribute: attributes,
        children: []
    };
    
    if (element.childNodes.length > 0) {
        for (let i = 0; i < element.childNodes.length; i++) {
            const child = element.childNodes[i];
            const childTree = getDOMTree(child);
            if (childTree) {
                tree.children.push(childTree);
            }
        }
    }
    
    return tree;
}

function traverseDOM() {
    const body = document.getElementsByTagName('html')[0];
    return getDOMTree(body);
}

(function () {
    console.log('hahahahahahah');
    window.webkit.messageHandlers.getDOMTree.postMessage(traverseDOM());
})();
