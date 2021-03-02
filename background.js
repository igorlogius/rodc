function onResponse(response) {
	console.log("Received " + response);
}

function onError(error) {
	console.log(`Error: ${error}`);
}

dl_store = {} // id => {url:"",filename:"" }

async function handleCreated(info) {
	console.log(`Download ${info.id} created.`);
	dl_store[info.id] = { "url": info.url, "file": info.filename };
}

async function handleChanged(delta) {
	if (delta.state && delta.state.current === "complete") {
		console.log(`Download ${delta.id} completed.`);
		try {
			const resp =  await browser.runtime.sendNativeMessage("rodc", dl_store[delta.id]);
			console.log("Received " + resp);
		}catch(e) {
			console.log(`Error: ${e}`);
		}
		delete dl_store[delta.id];
	}
	if (delta.state && delta.state.current === "interrupted") {
		console.log(`Download ${delta.id} was interrupted.`);
		delete dl_store[delta.id];
	}
}

browser.downloads.onCreated.addListener(handleCreated);
browser.downloads.onChanged.addListener(handleChanged);

