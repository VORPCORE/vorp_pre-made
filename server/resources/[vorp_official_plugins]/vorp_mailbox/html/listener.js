function showEditButtons(value) {
	document.getElementById("mailbox-buttons-letter").style.display = value === false ? 'none' : '';
}

function createNoMessageDiv() {
	if (document.getElementById('no-message') !== null) {
		return ;
	}

	const letterContainer = document.createElement('div');
	letterContainer.className = 'mailbox-letter-content';
	letterContainer.id = 'no-message';
	letterContainer.style.width = '700px';
	letterContainer.style.height = '100%';
	letterContainer.style.margin = '0 0 0 15px';
	letterContainer.style.color = 'black';
	letterContainer.style.display = 'flex';
	letterContainer.style.justifyContent = 'center';
	letterContainer.style.alignItems = 'center';

	const content = JSON.parse(window.localStorage.getItem('mailbox_language'))['UINoMessageReceived'];
	const noMessageText = document.createElement("p");
	noMessageText.textContent = content;
	noMessageText.style.fontSize = '30px';

	letterContainer.appendChild(noMessageText);

	document.getElementById("mailbox-content").appendChild(letterContainer);
}

function deleteNoMessageDiv() {
	const element = document.getElementById('no-message')
	if (element !== null) {
		element.parentElement.removeChild(element);
	}
}

function createLetterContent(data) {
	if (document.getElementById(`content-${data.id}`) !== null) {
		return ;
	}

	const letterContainer = document.createElement('div');
	letterContainer.className = 'mailbox-letter-content';
	letterContainer.id = `content-${data.id}`;
	letterContainer.style.width = '742px';
	letterContainer.style.height = '100%';
	letterContainer.style.color = 'white';
	letterContainer.style.border = '2px solid black';
	letterContainer.style.borderLeft = 'none';
	letterContainer.style.display = 'none';

	const letterAuthor = document.createElement("div");
	letterAuthor.className = 'mailbox-letter-from';
	letterAuthor.id = `author-${data.id}`;
	letterAuthor.textContent = `${data.firstname} ${data.lastname}`;

	const letterContent = document.createElement("p");
	letterContent.className = 'mailbox-letter-message';
	letterContent.id = `message-${data.id}`;

	const parsedMessage = data.message.replaceAll('\n', "<br>");
	letterContent.innerHTML = parsedMessage;

	letterContainer.appendChild(letterContent);
	letterContainer.appendChild(letterAuthor);

	document.getElementById("mailbox-content").appendChild(letterContainer);
}

function createLetterTitle(data) {
	if (document.getElementById(`letter-${data.id}`) !== null) {
		return ;
	}

	const lettersContainer = document.getElementById("mailbox-letters");

	const newLetter = document.createElement("li");
	newLetter.className = 'mailbox-letter'
	newLetter.id = `letter-${data.id}`;


	const prefix = JSON.parse(window.localStorage.getItem('mailbox_language'))['UINamePrefix'];
	const letterTitle = document.createElement("a");
	letterTitle.text = `${prefix} ${data.firstname} ${data.lastname}`
	letterTitle.id = `title-${data.id}`;

	if (data.opened === false) {
		letterTitle.style.fontWeight = 'bold';
	}

	letterTitle.dataset.id = data.id;
	letterTitle.dataset.steam = data.steam;
	letterTitle.dataset.firstname = data.firstname;
	letterTitle.dataset.lastname = data.lastname;
	letterTitle.href = '#';

	letterTitle.onclick = (event) => {
		document.getElementById(event.target.id).style.fontWeight = '';
		const id = event.target.dataset.id;

		const letters = JSON.parse(window.localStorage.getItem('mailbox_letters'));
		letters.forEach(letter => {
			if (letter.id === id) {
				letter.opened = true;
			}
		});
		window.localStorage.setItem('mailbox_letters', JSON.stringify(letters));

		showEditButtons(true);
		window.localStorage.setItem('selected_letter', JSON.stringify(event.target.dataset));

		const lettersElements = document.getElementsByClassName('mailbox-letter-content');
		for (let i = lettersElements.length - 1; i >= 0; i--) {
			if (lettersElements.item(i).id !== `content-${id}`) {
				lettersElements.item(i).style.display = 'none';
			} else {
				lettersElements.item(i).style.display = '';
			}
		}
	}

	const letterDate = document.createElement("a");
	const receivedAt = new Date(data.received_at);
	const hours = receivedAt.getUTCHours();
	const minutes = receivedAt.getUTCMinutes();
	letterDate.text = `${new Date(data.received_at).toDateString()} ${hours}H${minutes}`
	letterDate.className = 'letter-date';
	letterDate.id = `date-${data.id}`;

	newLetter.appendChild(letterTitle);
	newLetter.appendChild(letterDate);

	lettersContainer.appendChild(newLetter);
}

function createLetter(data) {
	createLetterTitle(data);
	createLetterContent(data);
}

function createUserSelectOption(name, id) {
	if (document.getElementById(name) !== null) {
		return ;
	}
	const userSelect = document.getElementById("mailbox-user-select");

	const userOption = document.createElement('option');
	userOption.textContent = name;
	userOption.id = name;
	userOption.value = id;

	userSelect.appendChild(userOption);
}

function navigateToWriteSection() {
	document.getElementById('mailbox-container-write').hidden = false;
	document.getElementById('mailbox-container-broadcast').hidden = true;
	document.getElementById('mailbox-container-read').hidden = true;
}

function navigateToReadSection() {
	document.getElementById('mailbox-container-write').hidden = true;
	document.getElementById('mailbox-container-broadcast').hidden = true;
	document.getElementById('mailbox-container-read').hidden = false;
}

function navigateToBroadcastSection() {
	document.getElementById('mailbox-container-write').hidden = true;
	document.getElementById('mailbox-container-read').hidden = true;
	document.getElementById('mailbox-container-broadcast').hidden = false;
}

function closeAllLetters() {
	const lettersElements = document.getElementsByClassName('mailbox-letter-content');
	for (let i = lettersElements.length - 1; i >= 0; i--) {
		lettersElements.item(i).style.display = 'none';
	}
}

function setMessages(messages) {
	if (messages.length === 0) {
		createNoMessageDiv();
		return ;
	} else {
		deleteNoMessageDiv();
	}

	// load letters into list
	window.localStorage.setItem('mailbox_letters', JSON.stringify(messages));
	messages.forEach((letter) => {
		createLetter(letter);
	});
}

function setUsers(users) {
	//load users into select
	createUserSelectOption('Choisis un destinataire', 0);
	window.localStorage.setItem('mailbox_users', JSON.stringify(users));
	users.forEach((user, index) => {
		createUserSelectOption(`${user.firstname} ${user.lastname}`, index + 1);
	});
}

function setLanguage(language) {
	window.localStorage.setItem('mailbox_language', JSON.stringify(language));

	document.getElementById('mailbox-read-button-close').textContent = language['UICloseButton'];
	document.getElementById('mailbox-button-write').textContent = language['UIWriteButton'];
	document.getElementById('mailbox-button-delete').textContent = language['UIDeleteButton'];
	document.getElementById('mailbox-button-answer').textContent = language['UIAnswerButton'];

	document.getElementById('mailbox-write-button-close').textContent = language['UICloseButton'];
	document.getElementById('mailbox-button-cancel').textContent = language['UIAbortButton'];
	document.getElementById('mailbox-button-send').textContent = language['UISendButton'];

	document.getElementById('mailbox-broadcast-button-close').textContent = language['UICloseButton'];
	document.getElementById('mailbox-button-broadcast-cancel').textContent = language['UIAbortButton'];
	document.getElementById('mailbox-button-broadcast').textContent = language['UISendButton'];
}

function initInteractions() {
	// add UI buttons interaction
	$('#mailbox-button-cancel').unbind().click(() => {
		navigateToReadSection();
	});

	$('#mailbox-button-write').unbind().click(() => {
		document.getElementById("mailbox-user-select").selectedIndex = '0';
		navigateToWriteSection();
	});

	$('#mailbox-button-answer').unbind().click(() => {
		const selectedLetter = JSON.parse(window.localStorage.getItem('selected_letter'));

		const name = `${selectedLetter.firstname} ${selectedLetter.lastname}`;

		const e = document.getElementById('mailbox-user-select');
		let optionToSelect = -1;

		for (let i = 0; i < e.options.length; i++) {
			if (e.options[i].id === name) {
				optionToSelect = i;
				break;
			}
		}

		if (optionToSelect < 0) {
			return ;
		}

		document.getElementById("mailbox-user-select").selectedIndex = optionToSelect.toString();
		navigateToWriteSection();
	});

	$('#mailbox-button-delete').unbind().click(() => {
		const selectedLetter = JSON.parse(window.localStorage.getItem('selected_letter'));
		const titleElement = document.getElementById(`letter-${selectedLetter.id}`);
		const contentElement = document.getElementById(`content-${selectedLetter.id}`);

		titleElement.parentElement.removeChild(titleElement);
		contentElement.parentElement.removeChild(contentElement);
		showEditButtons(false);

		const letters = JSON.parse(window.localStorage.getItem('mailbox_letters'));
		const remainingLetters = letters.filter(letter => letter.id !== selectedLetter.id);

		console.log(remainingLetters.length);

		if (remainingLetters.length === 0) {
			createNoMessageDiv();
		}
		window.localStorage.setItem('mailbox_letters', JSON.stringify(remainingLetters));
	});

	$('#mailbox-button-send').unbind().click(() => {
		const message = document.getElementById('mailbox-message-text').value;

		const e = document.getElementById('mailbox-user-select');
		const userId = e.options[e.selectedIndex].id;
		const receiver = JSON.parse(window.localStorage.getItem('mailbox_users')).find((user) => {
			const name = `${user.firstname} ${user.lastname}`;
			return (name === userId);
		});

		if (!!receiver && message.length > 0) {
			// send to Client
			$.post('http://vorp_mailbox/send', JSON.stringify({receiver, message}));
			document.getElementById('mailbox-message-text').value = '';
			navigateToReadSection();
		}
	});

	$('#mailbox-write-button-close').unbind().click(() => {
		const messages = window.localStorage.getItem('mailbox_letters');
		$.post('http://vorp_mailbox/close', JSON.stringify({messages}));
	});
	$('#mailbox-read-button-close').unbind().click(() => {
		const messages = window.localStorage.getItem('mailbox_letters');
		$.post('http://vorp_mailbox/close', JSON.stringify({messages}));
	});

	//Broadcast
	$('#mailbox-button-broadcast').unbind().click(() => {
		const message = document.getElementById('mailbox-broadcast-text').value;

		if (message.length > 0) {
			// send to Client
			$.post('http://vorp_mailbox/broadcast', JSON.stringify({message}));
			document.getElementById('mailbox-broadcast-text').value = '';
			$.post('http://vorp_mailbox/close', JSON.stringify({}));
		}
	});


	$('#mailbox-broadcast-button-close').unbind().click(() => {
		$.post('http://vorp_mailbox/close', JSON.stringify({}));
	});
	$('#mailbox-button-broadcast-cancel').unbind().click(() => {
		$.post('http://vorp_mailbox/close', JSON.stringify({}));
	});
}


window.onload = () => {
	//init windows
	navigateToReadSection();
	showEditButtons(false);
}

window.addEventListener('message', (event) => {
	/**
	 * @type {{
	 *     action: string,
	 *     users: string,
	 *     messages: string,
	 *     language: string
	 * }}
	 * */
	const message = event.data;


	switch (message.action) {
		case 'open':
			navigateToReadSection();
			$("body").show();
			break;
		case 'open_broadcast':
			navigateToBroadcastSection();
			$("body").show();
			break;
		case 'close':
			$("body").hide();
			closeAllLetters();
			break;
		case 'set_messages':
			setMessages(JSON.parse(message.messages));
			break;
		case 'set_users':
			setUsers(JSON.parse(message.users));
			break;
		case 'set_language':
			setLanguage(JSON
				.parse(message.language))
			break;
		default:
			return;
	}

	initInteractions();
});


